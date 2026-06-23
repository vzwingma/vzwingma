<#
.SYNOPSIS
    Syncs the `description` frontmatter field from OpenCode files (.opencode/)
    to their GitHub Copilot counterparts (.github/).

.DESCRIPTION
    Covers three file types:
      - Agents      : .opencode/agents/*.agent.md      → .github/agents/*.agent.md
      - Skills      : .opencode/skills/*/SKILL.md      → .github/skills/*/SKILL.md
      - Instructions: .opencode/instructions/*.md      → .github/instructions/*.md

    Prompts are intentionally excluded (descriptions are tool-specific).

.PARAMETER WhatIf
    Dry-run: shows what would change without writing any files.

.EXAMPLE
    .\sync-opencode-to-github.ps1
    .\sync-opencode-to-github.ps1 -WhatIf
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

$opencodeBase = Join-Path $repoRoot '.opencode'
$githubBase   = Join-Path $repoRoot '.github'

$totalSynced = 0
$totalOk     = 0
$totalWarn   = 0

function Add-Counts ($counts) {
    $script:totalSynced += $counts.synced
    $script:totalOk     += $counts.ok
    $script:totalWarn   += $counts.warn
}

# ── Agents ──────────────────────────────────────────────────────────────────
Write-Host "`n==> Agents (.opencode/agents/ → .github/agents/)" -ForegroundColor Magenta
$agentFiles = Get-ChildItem (Join-Path $opencodeBase 'agents') -Filter '*.agent.md' -File |
              Select-Object -ExpandProperty FullName
Add-Counts (Sync-AgentFiles -SourceFiles $agentFiles `
    -SourceBase (Join-Path $opencodeBase 'agents') `
    -TargetBase (Join-Path $githubBase 'agents') `
    -WhatIf:$WhatIf)

# ── Skills ───────────────────────────────────────────────────────────────────
Write-Host "`n==> Skills (.opencode/skills/ → .github/skills/)" -ForegroundColor Magenta
$skillFiles = Get-ChildItem (Join-Path $opencodeBase 'skills') -Filter 'SKILL.md' -Recurse -File |
              Select-Object -ExpandProperty FullName
Add-Counts (Sync-AgentFiles -SourceFiles $skillFiles `
    -SourceBase (Join-Path $opencodeBase 'skills') `
    -TargetBase (Join-Path $githubBase 'skills') `
    -WhatIf:$WhatIf)

# ── Instructions ─────────────────────────────────────────────────────────────
Write-Host "`n==> Instructions (.opencode/instructions/ → .github/instructions/)" -ForegroundColor Magenta
$instrFiles = Get-ChildItem (Join-Path $opencodeBase 'instructions') -Filter '*.md' -File |
              Select-Object -ExpandProperty FullName
Add-Counts (Sync-AgentFiles -SourceFiles $instrFiles `
    -SourceBase (Join-Path $opencodeBase 'instructions') `
    -TargetBase (Join-Path $githubBase 'instructions') `
    -WhatIf:$WhatIf)

# ── Summary ───────────────────────────────────────────────────────────────────
$mode = if ($WhatIf) { ' (dry-run)' } else { '' }
Write-Host "`n── Summary$mode ──────────────────────────────────────────────" -ForegroundColor White
Write-Host "  [SYNC] Updated : $totalSynced" -ForegroundColor Cyan
Write-Host "  [OK]   Already in sync: $totalOk" -ForegroundColor Green
if ($totalWarn -gt 0) {
    Write-Host "  [WARN] Skipped/missing : $totalWarn" -ForegroundColor Yellow
}
