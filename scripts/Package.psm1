<#
.SYNOPSIS
    Shared packaging helper for package-claude.ps1 / package-github.ps1 (AP 005 P6).

    New-HarnessPackage stages a declarative list of files/folders into a temporary directory and writes
    a ZIP whose entry names use forward slashes (portable to macOS/Linux unzip, unlike Compress-Archive
    on Windows PowerShell 5.1).
#>

function New-HarnessPackage {
    <#
    .PARAMETER RepoRoot   Repository root.
    .PARAMETER Items      Array of @{ Path = 'relative/src'; Optional = $true|$false }. Folders are copied
                          recursively, keeping their relative path.
    .PARAMETER Exclude    File name patterns excluded everywhere (e.g. 'SKILL.copilot.md').
    .PARAMETER ZipPath    Output ZIP path (overwritten).
    #>
    param(
        [Parameter(Mandatory)][string]$RepoRoot,
        [Parameter(Mandatory)][object[]]$Items,
        [string[]]$Exclude = @(),
        [Parameter(Mandatory)][string]$ZipPath
    )

    Add-Type -AssemblyName System.IO.Compression
    Add-Type -AssemblyName System.IO.Compression.FileSystem

    $files = New-Object System.Collections.Generic.List[object]
    foreach ($item in $Items) {
        $src = Join-Path $RepoRoot $item.Path
        if (-not (Test-Path $src)) {
            if ($item.Optional) { Write-Host "  - $($item.Path) (absent, ignoré)" -ForegroundColor DarkGray; continue }
            throw "Élément de package introuvable : $($item.Path)"
        }
        Write-Host "  + $($item.Path)"
        $candidates = if (Test-Path $src -PathType Container) { Get-ChildItem $src -Recurse -File } else { @(Get-Item $src) }
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
    if (Test-Path $ZipPath) { Remove-Item $ZipPath -Force }

    $stream  = [System.IO.File]::Open($ZipPath, [System.IO.FileMode]::CreateNew)
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

    $sizeKb = [Math]::Round((Get-Item $ZipPath).Length / 1KB, 1)
    Write-Host "`nPackage created: $ZipPath ($sizeKb KB, $($files.Count) files)" -ForegroundColor Green
    Write-Host "Top-level entries:" -ForegroundColor White
    $files | ForEach-Object { ($_.Entry -split '/')[0] } | Sort-Object -Unique | ForEach-Object { Write-Host "  $_" }
}

Export-ModuleMember -Function New-HarnessPackage
