<#
.SYNOPSIS
    Syncs content from Claude Code files (.claude/) to GitHub Copilot files (.github/).

.DESCRIPTION
    Covers:
      - Agents      : .claude/agents/*.agent.md      → .github/agents/*.agent.md
      - Skills      : .claude/skills/*/SKILL.md      → .github/skills/*/SKILL.md
      - Instructions: .claude/instructions/*.md      → .github/instructions/*.md
      - Root tmpl.  : .claude/CLAUDE.template.md     → .github/copilot-instructions.template.md
      - Standalone  : CHANGELOG.md, PLANS.md, README.md
      - Quick Start : QUICK_START_CLAUDE.md → QUICK_START_COPILOT.md

    For structured files (agents/skills/instructions):
      Syncs both the `description` frontmatter field AND the body content.
      Platform-specific frontmatter fields (model/tools) are preserved.

    For standalone .md files:
      Full file sync with automatic path/term substitution (.claude/ -> .github/).

.PARAMETER WhatIf
    Dry-run: shows what would change without writing any files.

.EXAMPLE
    .\sync-claude-to-github.ps1
    .\sync-claude-to-github.ps1 -WhatIf
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

$claudeBase = Join-Path $repoRoot '.claude'
$githubBase = Join-Path $repoRoot '.github'
$direction  = 'claude-to-github'

$totalSynced = 0; $totalOk = 0; $totalWarn = 0

function Add-Counts ($counts) {
    $script:totalSynced += $counts.synced
    $script:totalOk     += $counts.ok
    $script:totalWarn   += $counts.warn
}

# ── Agents ────────────────────────────────────────────────────────────────────
Write-Host "`n==> Agents (.claude/agents/ -> .github/agents/)" -ForegroundColor Magenta
$agentFiles = Get-ChildItem (Join-Path $claudeBase 'agents') -Filter '*.agent.md' -File |
              Select-Object -ExpandProperty FullName
Add-Counts (Sync-AgentFiles -SourceFiles $agentFiles `
    -SourceBase (Join-Path $claudeBase 'agents') `
    -TargetBase (Join-Path $githubBase 'agents') `
    -Direction $direction -WhatIf:$WhatIf)

# ── Skills ────────────────────────────────────────────────────────────────────
Write-Host "`n==> Skills (.claude/skills/ -> .github/skills/)" -ForegroundColor Magenta
$skillFiles = Get-ChildItem (Join-Path $claudeBase 'skills') -Filter 'SKILL.md' -Recurse -File |
              Select-Object -ExpandProperty FullName
Add-Counts (Sync-AgentFiles -SourceFiles $skillFiles `
    -SourceBase (Join-Path $claudeBase 'skills') `
    -TargetBase (Join-Path $githubBase 'skills') `
    -Direction $direction -WhatIf:$WhatIf)

# ── Instructions ──────────────────────────────────────────────────────────────
Write-Host "`n==> Instructions (.claude/instructions/ -> .github/instructions/)" -ForegroundColor Magenta
$instrFiles = Get-ChildItem (Join-Path $claudeBase 'instructions') -Filter '*.md' -File |
              Where-Object { $_.Name -notmatch '\.template\.md$' } |
              Select-Object -ExpandProperty FullName
if ($instrFiles) {
    Add-Counts (Sync-AgentFiles -SourceFiles $instrFiles `
        -SourceBase (Join-Path $claudeBase 'instructions') `
        -TargetBase (Join-Path $githubBase 'instructions') `
        -Direction $direction -WhatIf:$WhatIf)
} else {
    Write-Host "  [OK] No non-template instruction files to sync" -ForegroundColor Green
}

# ── Instructions Templates (sync with path/term substitution) ────────────────
Write-Host "`n==> Instructions Templates (.claude/instructions/*.template.md -> .github/instructions/)" -ForegroundColor Cyan
$templateFiles = Get-ChildItem (Join-Path $claudeBase 'instructions') -Filter '*.template.md' -File
$tc = @{ synced = 0; ok = 0; warn = 0 }
foreach ($file in $templateFiles) {
    $targetPath = Join-Path (Join-Path $githubBase 'instructions') $file.Name
    $tc[(Sync-StandaloneFile -SourceFile $file.FullName -TargetFile $targetPath `
        -Direction $direction -WhatIf:$WhatIf)]++
}
Add-Counts $tc

# ── Root instruction template (.claude/CLAUDE.template.md -> .github/copilot-instructions.template.md) ─
Write-Host "`n==> Root instruction template (.claude/CLAUDE.template.md -> .github/copilot-instructions.template.md)" -ForegroundColor Magenta
$rc = @{ synced = 0; ok = 0; warn = 0 }
$rc[(Sync-StandaloneFile -SourceFile (Join-Path $claudeBase 'CLAUDE.template.md') `
    -TargetFile (Join-Path $githubBase 'copilot-instructions.template.md') `
    -Direction $direction -WhatIf:$WhatIf)]++
Add-Counts $rc

# ── Standalone .md files ──────────────────────────────────────────────────────
Write-Host "`n==> Standalone files (.claude/ -> .github/)" -ForegroundColor Magenta
Add-Counts (Sync-StandaloneFiles `
    -FileNames @('CHANGELOG.md', 'PLANS.md', 'README.md') `
    -SourceBase $claudeBase `
    -TargetBase $githubBase `
    -Direction $direction -WhatIf:$WhatIf)

# ── Root Quick Start ──────────────────────────────────────────────────────────
Write-Host "`n==> Quick Start (QUICK_START_CLAUDE.md -> QUICK_START_COPILOT.md)" -ForegroundColor Magenta
$qsc = @{ synced = 0; ok = 0; warn = 0 }
$qsc[(Sync-StandaloneFile `
    -SourceFile (Join-Path $repoRoot 'QUICK_START_CLAUDE.md') `
    -TargetFile (Join-Path $repoRoot 'QUICK_START_COPILOT.md') `
    -Direction $direction -WhatIf:$WhatIf)]++
Add-Counts $qsc

# ── Summary ───────────────────────────────────────────────────────────────────
$mode = if ($WhatIf) { ' (dry-run)' } else { '' }
Write-Host "`n── Summary$mode ──────────────────────────────────────────────" -ForegroundColor White
Write-Host "  [SYNC/CREATE] Updated : $totalSynced" -ForegroundColor Cyan
Write-Host "  [OK]   Already in sync: $totalOk" -ForegroundColor Green
if ($totalWarn -gt 0) {
    Write-Host "  [WARN] Skipped/missing : $totalWarn" -ForegroundColor Yellow
}
