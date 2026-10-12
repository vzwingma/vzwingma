<#
.SYNOPSIS
    Generates a distributable ZIP of the GitHub Copilot multi-agent harness (generated from .claude/).

.DESCRIPTION
    Run scripts/sync-claude-to-github.ps1 first (the package is built from .github/ as it is on disk).

    Included:
      - .github/agents/, .github/skills/, .github/instructions/ (role instruction templates)
      - .github/copilot-instructions.template.md, CHANGELOG.md, PLANS.md, README.md
      - docs/ARCHITECTURE.template.md, docs/adr/ADR-TEMPLATE.md, docs/diagrams/
      - QUICK_START_COPILOT.md, SETUP_CHECKLIST.md
      - .agents/ (if present locally: optional third-party skills, e.g. caveman)

    Excluded (specific to this repository):
      - .github/copilot-instructions.md, .github/workflows/
      - docs/ARCHITECTURE.md, docs/adr/NNN-*.md, .claude/, scripts/, root README.md

    ZIP entries use forward slashes (portable unzip).

.PARAMETER OutputDir
    Directory where the ZIP will be written. Defaults to <repo-root>/dist.

.PARAMETER FileName
    Name of the ZIP file (without extension). Defaults to copilot-templates-<yyyyMMdd>.

.EXAMPLE
    .\scripts\package-github.ps1
    .\scripts\package-github.ps1 -OutputDir C:\tmp\release -FileName copilot-templates-v1.0
#>
[CmdletBinding()]
param(
    [string]$OutputDir = '',
    [string]$FileName  = ''
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$repoRoot = Split-Path $PSScriptRoot -Parent
Import-Module (Join-Path $PSScriptRoot 'Package.psm1') -Force -DisableNameChecking

if ($OutputDir -eq '') { $OutputDir = Join-Path $repoRoot 'dist' }
if ($FileName  -eq '') { $FileName  = "copilot-templates-$(Get-Date -Format 'yyyyMMdd')" }

$items = @(
    @{ Path = '.agents'; Optional = $true }
    @{ Path = '.github/agents' }
    @{ Path = '.github/skills' }
    @{ Path = '.github/instructions' }
    @{ Path = '.github/copilot-instructions.template.md' }
    @{ Path = '.github/CHANGELOG.md' }
    @{ Path = '.github/PLANS.md' }
    @{ Path = '.github/README.md' }
    @{ Path = 'docs/ARCHITECTURE.template.md' }
    @{ Path = 'docs/adr/ADR-TEMPLATE.md' }
    @{ Path = 'docs/diagrams'; Optional = $true }
    @{ Path = 'QUICK_START_COPILOT.md' }
    @{ Path = 'SETUP_CHECKLIST.md' }
)

New-HarnessPackage -RepoRoot $repoRoot -Items $items -ZipPath (Join-Path $OutputDir "$FileName.zip")
