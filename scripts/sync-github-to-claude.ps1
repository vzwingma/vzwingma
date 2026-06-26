<#
.SYNOPSIS
    Syncs content from GitHub Copilot files (.github/) to Claude Code files (.claude/).

.DESCRIPTION
    Covers:
      - Agents      : .github/agents/*.agent.md      → .claude/agents/*.agent.md
      - Skills      : .github/skills/*/SKILL.md      → .claude/skills/*/SKILL.md
      - Instructions: .github/instructions/*.md      → .claude/instructions/*.md
      - Standalone  : CHANGELOG.md, PLANS.md, README.md

    For structured files (agents/skills/instructions):
      Syncs both the `description` frontmatter field AND the body content.
      Platform-specific frontmatter fields (model/tools) are preserved.

    For standalone .md files:
      Full file sync with automatic path substitution (.github/ -> .claude/).

    Prompts are intentionally excluded (descriptions are tool-specific).

.PARAMETER WhatIf
    Dry-run: shows what would change without writing any files.

.EXAMPLE
    .\sync-github-to-claude.ps1
    .\sync-github-to-claude.ps1 -WhatIf
#>
[CmdletBinding()]
param(
    [switch]$WhatIf
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$repoRoot   = Split-Path $PSScriptRoot -Parent
$moduleFile = Join-Path $PSScriptRoot 'Sync-Description.psm1'

if (-not (Test-Path $moduleFile)) { Write-Error "Module not found: $moduleFile"; exit 1 }
Import-Module $moduleFile -Force -DisableNameChecking

$githubBase = Join-Path $repoRoot '.github'
$claudeBase = Join-Path $repoRoot '.claude'
$direction  = 'github-to-claude'

$totalSynced = 0; $totalOk = 0; $totalWarn = 0

function Add-Counts ($counts) {
    $script:totalSynced += $counts.synced
    $script:totalOk     += $counts.ok
    $script:totalWarn   += $counts.warn
}

# ── Agents ────────────────────────────────────────────────────────────────────
Write-Host "`n==> Agents (.github/agents/ -> .claude/agents/)" -ForegroundColor Magenta
$agentFiles = Get-ChildItem (Join-Path $githubBase 'agents') -Filter '*.agent.md' -File |
              Select-Object -ExpandProperty FullName
Add-Counts (Sync-AgentFiles -SourceFiles $agentFiles `
    -SourceBase (Join-Path $githubBase 'agents') `
    -TargetBase (Join-Path $claudeBase 'agents') `
    -Direction $direction -WhatIf:$WhatIf)

# ── Skills ────────────────────────────────────────────────────────────────────
Write-Host "`n==> Skills (.github/skills/ -> .claude/skills/)" -ForegroundColor Magenta
$skillFiles = Get-ChildItem (Join-Path $githubBase 'skills') -Filter 'SKILL.md' -Recurse -File |
              Select-Object -ExpandProperty FullName
Add-Counts (Sync-AgentFiles -SourceFiles $skillFiles `
    -SourceBase (Join-Path $githubBase 'skills') `
    -TargetBase (Join-Path $claudeBase 'skills') `
    -Direction $direction -WhatIf:$WhatIf)

# ── Instructions ──────────────────────────────────────────────────────────────
Write-Host "`n==> Instructions (.github/instructions/ -> .claude/instructions/)" -ForegroundColor Magenta
$instrFiles = Get-ChildItem (Join-Path $githubBase 'instructions') -Filter '*.md' -File |
              Where-Object { $_.Name -notmatch '\.template\.md$' } |
              Select-Object -ExpandProperty FullName
if ($instrFiles) {
    Add-Counts (Sync-AgentFiles -SourceFiles $instrFiles `
        -SourceBase (Join-Path $githubBase 'instructions') `
        -TargetBase (Join-Path $claudeBase 'instructions') `
        -Direction $direction -WhatIf:$WhatIf)
} else {
    Write-Host "  [OK] No non-template instruction files to sync" -ForegroundColor Green
}

# ── Instructions Templates (Copy for reference) ──────────────────────────────
Write-Host "`n==> Instructions Templates (.github/instructions/*.template.md -> .claude/instructions/)" -ForegroundColor Cyan
$templateFiles = Get-ChildItem (Join-Path $githubBase 'instructions') -Filter '*.template.md' -File
foreach ($file in $templateFiles) {
    $relativePath = $file.Name
    $targetPath = Join-Path (Join-Path $claudeBase 'instructions') $relativePath

    if ($WhatIf) {
        Write-Host "  [COPY] $($file.FullName) -> $targetPath" -ForegroundColor Cyan
    } else {
        Copy-Item -Path $file.FullName -Destination $targetPath -Force
        Write-Host "  [COPY] $relativePath OK" -ForegroundColor Green
    }
}

# ── Standalone .md files ──────────────────────────────────────────────────────
Write-Host "`n==> Standalone files (.github/ -> .claude/)" -ForegroundColor Magenta
Add-Counts (Sync-StandaloneFiles `
    -FileNames @('CHANGELOG.md', 'PLANS.md', 'README.md') `
    -SourceBase $githubBase `
    -TargetBase $claudeBase `
    -Direction $direction -WhatIf:$WhatIf)

# ── Summary ───────────────────────────────────────────────────────────────────
$mode = if ($WhatIf) { ' (dry-run)' } else { '' }
Write-Host "`n── Summary$mode ──────────────────────────────────────────────" -ForegroundColor White
Write-Host "  [SYNC/CREATE] Updated : $totalSynced" -ForegroundColor Cyan
Write-Host "  [OK]   Already in sync: $totalOk" -ForegroundColor Green
if ($totalWarn -gt 0) {
    Write-Host "  [WARN] Skipped/missing : $totalWarn" -ForegroundColor Yellow
}
