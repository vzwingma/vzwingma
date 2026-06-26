<#
.SYNOPSIS
    Generates a distributable ZIP package of the OpenCode multi-agent templates.

.DESCRIPTION
    Copies a curated subset of the repository into a temporary staging directory,
    then compresses it into a ZIP file under /dist/.

    Included in the package:
      - .opencode/                               (everything)
      - .opencode/agents/
      - .opencode/instructions/
      - .opencode/prompts/
      - .opencode/skills/
      - .opencode/CHANGELOG.md
      - .opencode/PLANS.md
      - .opencode/README.md
      - docs/   (excluding ARCHITECTURE.md, adr/)
      - QUICK_START.md
      - SETUP_CHECKLIST.md

    Excluded:
      - .github/, .claude/, scripts/, .git/, .gitignore, .copilotignore
      - README.md (root), *.code-workspace
      - .opencode/plans/  (internal action plans)
      - docs/ARCHITECTURE.md  (transverse repo architecture doc)
      - docs/adr/  (ADR decisions)
      - dist/  (output directory itself)

.PARAMETER OutputDir
    Directory where the ZIP will be written. Defaults to <repo-root>/dist.

.PARAMETER FileName
    Name of the ZIP file (without extension). Defaults to opencode-templates-<yyyyMMdd>.

.EXAMPLE
    .\scripts\package-opencode.ps1
    .\scripts\package-opencode.ps1 -OutputDir C:\tmp\release -FileName opencode-templates-v1.0
#>
[CmdletBinding()]
param(
    [string]$OutputDir = '',
    [string]$FileName  = ''
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$repoRoot = Split-Path $PSScriptRoot -Parent

if ($OutputDir -eq '') { $OutputDir = Join-Path $repoRoot 'dist' }
if ($FileName  -eq '') { $FileName  = "opencode-templates-$(Get-Date -Format 'yyyyMMdd')" }

$zipPath = Join-Path $OutputDir "$FileName.zip"

# ── Staging directory ────────────────────────────────────────────────────────
$stagingDir = Join-Path ([System.IO.Path]::GetTempPath()) "opencode-pkg-$(Get-Random)"
Write-Host "Staging → $stagingDir"

function Stage-Dir {
    param([string]$SrcDir, [string]$RelDest)
    $dest = Join-Path $stagingDir $RelDest
    New-Item -ItemType Directory -Path $dest -Force | Out-Null
    Copy-Item -Path "$SrcDir\*" -Destination $dest -Recurse -Force
}

function Stage-File {
    param([string]$SrcFile, [string]$RelDir = '')
    $destDir = if ($RelDir) { Join-Path $stagingDir $RelDir } else { $stagingDir }
    New-Item -ItemType Directory -Path $destDir -Force | Out-Null
    Copy-Item -Path $SrcFile -Destination $destDir -Force
}

try {
    New-Item -ItemType Directory -Path $stagingDir -Force | Out-Null

    # ── .opencode/ ──────────────────────────────────────────────────────────────
    Write-Host "  + .opencode/agents/"
    Stage-Dir (Join-Path $repoRoot '.opencode\agents') '.opencode\agents'

    Write-Host "  + .opencode/instructions/"
    Stage-Dir (Join-Path $repoRoot '.opencode\instructions') '.opencode\instructions'

    Write-Host "  + .opencode/prompts/"
    $promptsSrc = Join-Path $repoRoot '.opencode\prompts'
    if (Test-Path $promptsSrc) {
        Stage-Dir $promptsSrc '.opencode\prompts'
    }

    Write-Host "  + .opencode/skills/"
    Stage-Dir (Join-Path $repoRoot '.opencode\skills') '.opencode\skills'

    Write-Host "  + .opencode/CHANGELOG.md"
    Stage-File (Join-Path $repoRoot '.opencode\CHANGELOG.md') '.opencode'

    Write-Host "  + .opencode/PLANS.md"
    Stage-File (Join-Path $repoRoot '.opencode\PLANS.md') '.opencode'

    Write-Host "  + .opencode/README.md"
    Stage-File (Join-Path $repoRoot '.opencode\README.md') '.opencode'

    # ── docs/ (excluding ARCHITECTURE.md) ────────────────────────────────────
    Write-Host "  + docs/ (excl. ARCHITECTURE.md)"
    $docsStaging = Join-Path $stagingDir 'docs'
    New-Item -ItemType Directory -Path $docsStaging -Force | Out-Null
    Get-ChildItem (Join-Path $repoRoot 'docs') -File |
        Where-Object { $_.Name -ne 'ARCHITECTURE.md' } |
        ForEach-Object { Copy-Item $_.FullName $docsStaging -Force }
    # ── Root files ────────────────────────────────────────────────────────────
    Write-Host "  + QUICK_START.md"
    Stage-File (Join-Path $repoRoot 'QUICK_START.md')

    Write-Host "  + SETUP_CHECKLIST.md"
    Stage-File (Join-Path $repoRoot 'SETUP_CHECKLIST.md')

    # ── ZIP ───────────────────────────────────────────────────────────────────
    New-Item -ItemType Directory -Path $OutputDir -Force | Out-Null

    if (Test-Path $zipPath) { Remove-Item $zipPath -Force }

    Write-Host "`nCompressing → $zipPath"
    Compress-Archive -Path "$stagingDir\*" -DestinationPath $zipPath -CompressionLevel Optimal

    $size = (Get-Item $zipPath).Length
    $sizeKb = [Math]::Round($size / 1KB, 1)
    Write-Host "`n✅ Package created: $zipPath ($sizeKb KB)" -ForegroundColor Green

    # List top-level entries in zip
    Write-Host "`nZip contents (top-level):" -ForegroundColor White
    Add-Type -AssemblyName System.IO.Compression.FileSystem
    $zip = [System.IO.Compression.ZipFile]::OpenRead($zipPath)
    $zip.Entries |
        ForEach-Object { $_.FullName -replace '[\\/].*', '' } |
        Sort-Object -Unique |
        ForEach-Object { Write-Host "  $_" }
    $zip.Dispose()

} finally {
    if (Test-Path $stagingDir) {
        Remove-Item $stagingDir -Recurse -Force
    }
}
