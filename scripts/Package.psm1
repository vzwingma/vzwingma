<#
.SYNOPSIS
    Shared packaging helper for package-claude.ps1 / package-github.ps1 (AP 005 P6).

    New-HarnessPackage stages a declarative list of files/folders into a temporary directory and writes
    a ZIP whose entry names use forward slashes (portable to macOS/Linux unzip, unlike Compress-Archive
    on Windows PowerShell 5.1).
#>

Import-Module (Join-Path $PSScriptRoot 'Harness-Paths.psm1') -DisableNameChecking

function Assert-HarnessCheck {
    <#
    .SYNOPSIS  Blocking gate before packaging: runs check-harness.ps1 (incl. the stale-render check of .github/)
               in a separate process and throws on any failure (AP 006 T2.3).
    #>
    param([Parameter(Mandatory)][string]$RepoRoot)

    $script = Join-Path $RepoRoot 'scripts\check-harness.ps1'
    $psExe  = (Get-Process -Id $PID).Path
    Write-Host "==> Contrôle bloquant : scripts/check-harness.ps1" -ForegroundColor Magenta
    & $psExe -NoProfile -ExecutionPolicy Bypass -File $script
    if ($LASTEXITCODE -ne 0) {
        throw "check-harness a échoué (code $LASTEXITCODE) : package non généré. Corriger puis relancer (rendu .github/ périmé : scripts/sync-claude-to-github.ps1)."
    }
}

function New-HarnessPackage {
    <#
    .PARAMETER RepoRoot   Repository root.
    .PARAMETER Items      Array of @{ Path = 'relative/src'; Optional = $true|$false }. Folders are copied
                          recursively, keeping their relative path.
    .PARAMETER Exclude    File name patterns excluded everywhere (e.g. 'SKILL.copilot.md').
    .PARAMETER ZipPath    Output ZIP path. An existing archive is never overwritten (error).
    #>
    param(
        [Parameter(Mandatory)][string]$RepoRoot,
        [Parameter(Mandatory)][object[]]$Items,
        [string[]]$Exclude = @(),
        [Parameter(Mandatory)][string]$ZipPath
    )

    $RepoRoot = [System.IO.Path]::GetFullPath($RepoRoot).TrimEnd('\', '/')
    Add-Type -AssemblyName System.IO.Compression
    Add-Type -AssemblyName System.IO.Compression.FileSystem

    # Never overwrite or delete an existing archive (AP 006 T2.3): refuse before doing any work.
    if (Test-Path -LiteralPath $ZipPath) {
        throw "Archive existante, écrasement refusé : $ZipPath (choisir un autre -FileName ou -OutputDir)."
    }

    $files = New-Object System.Collections.Generic.List[object]
    foreach ($item in $Items) {
        $src = Join-Path $RepoRoot $item.Path
        if (-not (Test-Path $src)) {
            if ($item.Optional) { Write-Host "  - $($item.Path) (absent, ignoré)" -ForegroundColor DarkGray; continue }
            throw "Élément de package introuvable : $($item.Path)"
        }
        if (Test-HarnessExcludedPath -RepoRoot $RepoRoot -Path $src) {
            throw "Élément de package exclu (.copilotignore ou exclusion par défaut) : $($item.Path)"
        }
        Write-Host "  + $($item.Path)"
        $candidates = if (Test-Path $src -PathType Container) { @(Get-HarnessFiles -RepoRoot $RepoRoot -Path $src -Recurse) } else { @(Get-Item $src) }
        foreach ($f in $candidates) {
            $skip = $false
            foreach ($pattern in $Exclude) { if ($f.Name -like $pattern) { $skip = $true } }
            if ($skip) { continue }
            $entry = $f.FullName.Substring($RepoRoot.Length).TrimStart('\', '/').Replace('\', '/')
            $files.Add([pscustomobject]@{ Source = $f.FullName; Entry = $entry })
        }
    }

    $outDir = Split-Path $ZipPath -Parent
    if (-not (Test-Path $outDir)) { New-Item -ItemType Directory -Path $outDir -Force | Out-Null }

    # Write to a unique temp name, then rename: a failed run leaves a '.partial' file that never blocks a rerun.
    $partial = "$ZipPath.$PID.partial"
    $stream  = [System.IO.File]::Open($partial, [System.IO.FileMode]::CreateNew)
    $archive = New-Object System.IO.Compression.ZipArchive($stream, [System.IO.Compression.ZipArchiveMode]::Create)
    try {
        foreach ($f in $files) {
            [void][System.IO.Compression.ZipFileExtensions]::CreateEntryFromFile(
                $archive, $f.Source, $f.Entry, [System.IO.Compression.CompressionLevel]::Optimal)
        }
    } finally {
        $archive.Dispose()
        $stream.Dispose()
    }
    if (Test-Path -LiteralPath $ZipPath) { throw "Archive apparue pendant la génération, écrasement refusé : $ZipPath (résultat conservé : $partial)." }
    Move-Item -LiteralPath $partial -Destination $ZipPath

    $sizeKb = [Math]::Round((Get-Item $ZipPath).Length / 1KB, 1)
    Write-Host "`nPackage created: $ZipPath ($sizeKb KB, $($files.Count) files)" -ForegroundColor Green
    Write-Host "Top-level entries:" -ForegroundColor White
    $files | ForEach-Object { ($_.Entry -split '/')[0] } | Sort-Object -Unique | ForEach-Object { Write-Host "  $_" }
}

Export-ModuleMember -Function New-HarnessPackage, Assert-HarnessCheck
