<#
.SYNOPSIS
    Syncs content from OpenCode files (.opencode/) to their GitHub Copilot counterparts (.github/).

.DESCRIPTION
    Covers:
      - Agents      : .opencode/agents/*.agent.md      → .github/agents/*.agent.md
      - Skills      : .opencode/skills/*/SKILL.md      → .github/skills/*/SKILL.md
      - Instructions: .opencode/instructions/*.md      → .github/instructions/*.md
      - Standalone  : PLANS.md, README.md

    For structured files (agents/skills/instructions):
      Syncs both the `description` frontmatter field AND the body content.
      Platform-specific frontmatter fields (mode/permission) are preserved.

    For standalone .md files:
      Full file sync with automatic path substitution (.opencode/ → .github/).

    Prompts are intentionally excluded (descriptions are tool-specific).
    CHANGELOG.md is excluded (only exists in .github/, canonical source is there).

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

$repoRoot   = Split-Path $PSScriptRoot -Parent
$moduleFile = Join-Path $PSScriptRoot 'Sync-Description.psm1'

if (-not (Test-Path $moduleFile)) { Write-Error "Module not found: $moduleFile"; exit 1 }
Import-Module $moduleFile -Force

$opencodeBase = Join-Path $repoRoot '.opencode'
$githubBase   = Join-Path $repoRoot '.github'
$direction    = 'opencode-to-github'

$totalSynced = 0; $totalOk = 0; $totalWarn = 0

function Add-Counts ($counts) {
    $script:totalSynced += $counts.synced
    $script:totalOk     += $counts.ok
    $script:totalWarn   += $counts.warn
}

# ── Agents ────────────────────────────────────────────────────────────────────
Write-Host "`n==> Agents (.opencode/agents/ → .github/agents/)" -ForegroundColor Magenta
$agentFiles = Get-ChildItem (Join-Path $opencodeBase 'agents') -Filter '*.agent.md' -File |
              Select-Object -ExpandProperty FullName
Add-Counts (Sync-AgentFiles -SourceFiles $agentFiles `
    -SourceBase (Join-Path $opencodeBase 'agents') `
    -TargetBase (Join-Path $githubBase 'agents') `
    -Direction $direction -WhatIf:$WhatIf)

# ── Skills ────────────────────────────────────────────────────────────────────
Write-Host "`n==> Skills (.opencode/skills/ → .github/skills/)" -ForegroundColor Magenta
$skillFiles = Get-ChildItem (Join-Path $opencodeBase 'skills') -Filter 'SKILL.md' -Recurse -File |
              Select-Object -ExpandProperty FullName
Add-Counts (Sync-AgentFiles -SourceFiles $skillFiles `
    -SourceBase (Join-Path $opencodeBase 'skills') `
    -TargetBase (Join-Path $githubBase 'skills') `
    -Direction $direction -WhatIf:$WhatIf)

# ── Instructions ──────────────────────────────────────────────────────────────
Write-Host "`n==> Instructions (.opencode/instructions/ → .github/instructions/)" -ForegroundColor Magenta
$instrFiles = Get-ChildItem (Join-Path $opencodeBase 'instructions') -Filter '*.md' -File |
              Select-Object -ExpandProperty FullName
Add-Counts (Sync-AgentFiles -SourceFiles $instrFiles `
    -SourceBase (Join-Path $opencodeBase 'instructions') `
    -TargetBase (Join-Path $githubBase 'instructions') `
    -Direction $direction -WhatIf:$WhatIf)

# ── Standalone .md files ──────────────────────────────────────────────────────
Write-Host "`n==> Standalone files (.opencode/ → .github/)" -ForegroundColor Magenta
Add-Counts (Sync-StandaloneFiles `
    -FileNames @('PLANS.md', 'README.md') `
    -SourceBase $opencodeBase `
    -TargetBase $githubBase `
    -Direction $direction -WhatIf:$WhatIf)

# ── Summary ───────────────────────────────────────────────────────────────────
$mode = if ($WhatIf) { ' (dry-run)' } else { '' }
Write-Host "`n── Summary$mode ──────────────────────────────────────────────" -ForegroundColor White
Write-Host "  [SYNC/CREATE] Updated : $totalSynced" -ForegroundColor Cyan
Write-Host "  [OK]   Already in sync: $totalOk" -ForegroundColor Green
if ($totalWarn -gt 0) {
    Write-Host "  [WARN] Skipped/missing : $totalWarn" -ForegroundColor Yellow
}
