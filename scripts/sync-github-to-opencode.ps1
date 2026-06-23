<#
.SYNOPSIS
    Syncs the `description` frontmatter field from GitHub Copilot files (.github/)
    to their OpenCode counterparts (.opencode/).

.DESCRIPTION
    Covers three file types:
      - Agents      : .github/agents/*.agent.md      → .opencode/agents/*.agent.md
      - Skills      : .github/skills/*/SKILL.md      → .opencode/skills/*/SKILL.md
      - Instructions: .github/instructions/*.md      → .opencode/instructions/*.md

    Prompts are intentionally excluded (descriptions are tool-specific).

.PARAMETER WhatIf
    Dry-run: shows what would change without writing any files.

.EXAMPLE
    .\sync-github-to-opencode.ps1
    .\sync-github-to-opencode.ps1 -WhatIf
#>
[CmdletBinding()]
param(
    [switch]$WhatIf
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

# Resolve repo root (parent of this scripts/ folder)
$repoRoot = Split-Path $PSScriptRoot -Parent
$moduleFile = Join-Path $PSScriptRoot 'Sync-Description.psm1'

if (-not (Test-Path $moduleFile)) {
    Write-Error "Module not found: $moduleFile"
    exit 1
}
Import-Module $moduleFile -Force

$githubBase  = Join-Path $repoRoot '.github'
$opencodeBase = Join-Path $repoRoot '.opencode'

$totalSynced = 0
$totalOk     = 0
$totalWarn   = 0

function Add-Counts ($counts) {
    $script:totalSynced += $counts.synced
    $script:totalOk     += $counts.ok
    $script:totalWarn   += $counts.warn
}

# ── Agents ──────────────────────────────────────────────────────────────────
Write-Host "`n==> Agents (.github/agents/ → .opencode/agents/)" -ForegroundColor Magenta
$agentFiles = Get-ChildItem (Join-Path $githubBase 'agents') -Filter '*.agent.md' -File |
              Select-Object -ExpandProperty FullName
Add-Counts (Sync-AgentFiles -SourceFiles $agentFiles `
    -SourceBase (Join-Path $githubBase 'agents') `
    -TargetBase (Join-Path $opencodeBase 'agents') `
    -WhatIf:$WhatIf)

# ── Skills ───────────────────────────────────────────────────────────────────
Write-Host "`n==> Skills (.github/skills/ → .opencode/skills/)" -ForegroundColor Magenta
$skillFiles = Get-ChildItem (Join-Path $githubBase 'skills') -Filter 'SKILL.md' -Recurse -File |
              Select-Object -ExpandProperty FullName
Add-Counts (Sync-AgentFiles -SourceFiles $skillFiles `
    -SourceBase (Join-Path $githubBase 'skills') `
    -TargetBase (Join-Path $opencodeBase 'skills') `
    -WhatIf:$WhatIf)

# ── Instructions ─────────────────────────────────────────────────────────────
Write-Host "`n==> Instructions (.github/instructions/ → .opencode/instructions/)" -ForegroundColor Magenta
$instrFiles = Get-ChildItem (Join-Path $githubBase 'instructions') -Filter '*.md' -File |
              Select-Object -ExpandProperty FullName
Add-Counts (Sync-AgentFiles -SourceFiles $instrFiles `
    -SourceBase (Join-Path $githubBase 'instructions') `
    -TargetBase (Join-Path $opencodeBase 'instructions') `
    -WhatIf:$WhatIf)

# ── Summary ───────────────────────────────────────────────────────────────────
$mode = if ($WhatIf) { ' (dry-run)' } else { '' }
Write-Host "`n── Summary$mode ──────────────────────────────────────────────" -ForegroundColor White
Write-Host "  [SYNC] Updated : $totalSynced" -ForegroundColor Cyan
Write-Host "  [OK]   Already in sync: $totalOk" -ForegroundColor Green
if ($totalWarn -gt 0) {
    Write-Host "  [WARN] Skipped/missing : $totalWarn" -ForegroundColor Yellow
}
