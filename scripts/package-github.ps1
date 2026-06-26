<#
.SYNOPSIS
    Generates a distributable ZIP package of the Copilot multi-agent templates.

.DESCRIPTION
    Copies a curated subset of the repository into a temporary staging directory,
    then compresses it into a ZIP file under /dist/.

    Included in the package:
      - .agents/                               (everything)
      - .github/agents/                        
      - .github/instructions/
      - .github/prompts/
      - .github/skills/
      - .github/CHANGELOG.md
      - .github/PLANS.md
      - .github/copilot-instructions.template.md
      - docs/   (excluding ARCHITECTURE.md)
      - QUICK_START.md
      - SETUP_CHECKLIST.md

    Excluded:
      - .opencode/, scripts/, .git/, .gitignore, .copilotignore
      - README.md (root), AGENTS.md, skills-lock.json, *.code-workspace
      - .github/plans/  (internal action plans)
      - .github/copilot-instructions.md  (transverse repo instructions, not the template)
      - docs/ARCHITECTURE.md  (transverse repo architecture doc)
      - dist/  (output directory itself)

.PARAMETER OutputDir
    Directory where the ZIP will be written. Defaults to <repo-root>/dist.

.PARAMETER FileName
    Name of the ZIP file (without extension). Defaults to copilot-templates-<yyyyMMdd>.

.EXAMPLE
    .\scripts\package.ps1
    .\scripts\package.ps1 -OutputDir C:\tmp\release -FileName copilot-templates-v1.0
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
if ($FileName  -eq '') { $FileName  = "copilot-templates-$(Get-Date -Format 'yyyyMMdd')" }

$zipPath = Join-Path $OutputDir "$FileName.zip"

# ── Staging directory ────────────────────────────────────────────────────────
$stagingDir = Join-Path ([System.IO.Path]::GetTempPath()) "copilot-pkg-$(Get-Random)"
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

    # ── .agents/ ─────────────────────────────────────────────────────────────
    Write-Host "  + .agents/"
    Stage-Dir (Join-Path $repoRoot '.agents') '.agents'

    # ── .github/ (selective) ─────────────────────────────────────────────────
    Write-Host "  + .github/agents/"
    Stage-Dir (Join-Path $repoRoot '.github\agents') '.github\agents'

    Write-Host "  + .github/instructions/"
    Stage-Dir (Join-Path $repoRoot '.github\instructions') '.github\instructions'

    Write-Host "  + .github/prompts/"
    Stage-Dir (Join-Path $repoRoot '.github\prompts') '.github\prompts'

    Write-Host "  + .github/skills/"
    Stage-Dir (Join-Path $repoRoot '.github\skills') '.github\skills'

    Write-Host "  + .github/CHANGELOG.md"
    Stage-File (Join-Path $repoRoot '.github\CHANGELOG.md') '.github'

    Write-Host "  + .github/PLANS.md"
    Stage-File (Join-Path $repoRoot '.github\PLANS.md') '.github'

    Write-Host "  + .github/copilot-instructions.template.md"
    Stage-File (Join-Path $repoRoot '.github\copilot-instructions.template.md') '.github'

    # ── docs/ (excluding ARCHITECTURE.md) ────────────────────────────────────
    Write-Host "  + docs/ (excl. ARCHITECTURE.md)"
    $docsStaging = Join-Path $stagingDir 'docs'
    New-Item -ItemType Directory -Path $docsStaging -Force | Out-Null
    Get-ChildItem (Join-Path $repoRoot 'docs') -File |
        Where-Object { $_.Name -ne 'ARCHITECTURE.md' } |
        ForEach-Object { Copy-Item $_.FullName $docsStaging -Force }
    # docs/adr/ subtree
    $adrSrc = Join-Path $repoRoot 'docs\adr'
    if (Test-Path $adrSrc) {
        Stage-Dir $adrSrc 'docs\adr'
    }

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
