<#
.SYNOPSIS
    Generates a distributable ZIP of the Claude Code multi-agent harness.

.DESCRIPTION
    Included:
      - .claude/agents/, .claude/skills/ (without SKILL.copilot.md variants), .claude/hooks/
      - .claude/settings.template.json   (permissions + guard hook, merged by /init-harness)
      - .claude/CLAUDE.template.md, CHANGELOG.md, PLANS.md, README.md
      - docs/ARCHITECTURE.template.md, docs/adr/ADR-TEMPLATE.md, docs/diagrams/
      - QUICK_START_CLAUDE.md, SETUP_CHECKLIST.md

    Excluded (specific to this repository):
      - .claude/CLAUDE.md, .claude/settings.json, docs/plans/
      - docs/ARCHITECTURE.md, docs/adr/NNN-*.md (decisions of this repository)
      - .github/, scripts/, root README.md

    ZIP entries use forward slashes (portable unzip). Optional dependency: caveman plugin/skills
    (communication mode); the rules are also written in CLAUDE.template.md.

.PARAMETER OutputDir
    Directory where the ZIP will be written. Defaults to <repo-root>/dist.

.PARAMETER FileName
    Name of the ZIP file (without extension). Defaults to claude-templates-<yyyyMMdd>.

.EXAMPLE
    .\scripts\package-claude.ps1
    .\scripts\package-claude.ps1 -OutputDir C:\tmp\release -FileName claude-templates-v1.0
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
Assert-HarnessCheck -RepoRoot $repoRoot

if ($OutputDir -eq '') { $OutputDir = Join-Path $repoRoot 'dist' }
if ($FileName  -eq '') { $FileName  = "claude-templates-$(Get-Date -Format 'yyyyMMdd')" }

$items = @(
    @{ Path = '.claude/agents' }
    @{ Path = '.claude/skills' }
    @{ Path = '.claude/hooks' }
    @{ Path = '.claude/settings.template.json' }
    @{ Path = '.claude/CLAUDE.template.md' }
    @{ Path = '.claude/CHANGELOG.md' }
    @{ Path = '.claude/PLANS.md' }
    @{ Path = '.claude/README.md' }
    @{ Path = 'docs/ARCHITECTURE.template.md' }
    @{ Path = 'docs/adr/ADR-TEMPLATE.md' }
    @{ Path = 'docs/diagrams'; Optional = $true }
    @{ Path = 'QUICK_START_CLAUDE.md' }
    @{ Path = 'SETUP_CHECKLIST.md' }
)

New-HarnessPackage -RepoRoot $repoRoot -Items $items -Exclude @('SKILL.copilot.md') `
    -ZipPath (Join-Path $OutputDir "$FileName.zip")
