<#
.SYNOPSIS
    Syncs content from OpenCode files (.opencode/) to Claude Code files (.claude/).

.DESCRIPTION
    Mirrors the GitHub-to-Claude sync but sources from .opencode/ instead.

    Covers:
      - Agents      : .opencode/agents/*.agent.md      → .claude/agents/*.agent.md
      - Skills      : .opencode/skills/*/SKILL.md      → .claude/skills/*/SKILL.md
      - Instructions: .opencode/instructions/*.md      → .claude/instructions/*.md
      - Standalone  : CHANGELOG.md, PLANS.md, README.md
      - Quick Start : QUICK_START_OPENCODE.md → QUICK_START_CLAUDE.md

    For structured files (agents/skills/instructions):
      Syncs both the `description` frontmatter field AND the body content.
      Platform-specific frontmatter fields (model/tools) are preserved.

    For standalone .md files:
      Full file sync with automatic path substitution (.opencode/ -> .claude/).

.PARAMETER WhatIf
    Dry-run: shows what would change without writing any files.

.EXAMPLE
    .\sync-opencode-to-claude.ps1
    .\sync-opencode-to-claude.ps1 -WhatIf
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

$opencodeBase = Join-Path $repoRoot '.opencode'
$claudeBase   = Join-Path $repoRoot '.claude'
$direction    = 'opencode-to-claude'

$totalSynced = 0; $totalOk = 0; $totalWarn = 0

function Add-Counts ($counts) {
    $script:totalSynced += $counts.synced
    $script:totalOk     += $counts.ok
    $script:totalWarn   += $counts.warn
}

# ── Agents ────────────────────────────────────────────────────────────────────
Write-Host "`n==> Agents (.opencode/agents/ -> .claude/agents/)" -ForegroundColor Magenta
$agentFiles = Get-ChildItem (Join-Path $opencodeBase 'agents') -Filter '*.agent.md' -File |
              Select-Object -ExpandProperty FullName
Add-Counts (Sync-AgentFiles -SourceFiles $agentFiles `
    -SourceBase (Join-Path $opencodeBase 'agents') `
    -TargetBase (Join-Path $claudeBase 'agents') `
    -Direction $direction -WhatIf:$WhatIf)

# ── Skills ────────────────────────────────────────────────────────────────────
Write-Host "`n==> Skills (.opencode/skills/ -> .claude/skills/)" -ForegroundColor Magenta
$skillFiles = Get-ChildItem (Join-Path $opencodeBase 'skills') -Filter 'SKILL.md' -Recurse -File |
              Select-Object -ExpandProperty FullName
Add-Counts (Sync-AgentFiles -SourceFiles $skillFiles `
    -SourceBase (Join-Path $opencodeBase 'skills') `
    -TargetBase (Join-Path $claudeBase 'skills') `
    -Direction $direction -WhatIf:$WhatIf)

# ── Instructions ──────────────────────────────────────────────────────────────
Write-Host "`n==> Instructions (.opencode/instructions/ -> .claude/instructions/)" -ForegroundColor Magenta
$instrFiles = Get-ChildItem (Join-Path $opencodeBase 'instructions') -Filter '*.md' -File |
              Where-Object { $_.Name -notmatch '\.template\.md$' } |
              Select-Object -ExpandProperty FullName
if ($instrFiles) {
    Add-Counts (Sync-AgentFiles -SourceFiles $instrFiles `
        -SourceBase (Join-Path $opencodeBase 'instructions') `
        -TargetBase (Join-Path $claudeBase 'instructions') `
        -Direction $direction -WhatIf:$WhatIf)
} else {
    Write-Host "  [OK] No non-template instruction files to sync" -ForegroundColor Green
}

# ── Instructions Templates (Copy for reference) ──────────────────────────────
Write-Host "`n==> Instructions Templates (.opencode/instructions/*.template.md -> .claude/instructions/)" -ForegroundColor Cyan
$templateDir = Join-Path $opencodeBase 'instructions'
if (Test-Path $templateDir) {
    $templateFiles = Get-ChildItem $templateDir -Filter '*.template.md' -File
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
} else {
    Write-Host "  [OK] No template directory found" -ForegroundColor Green
}

# ── Standalone .md files ──────────────────────────────────────────────────────
Write-Host "`n==> Standalone files (.opencode/ -> .claude/)" -ForegroundColor Magenta
Add-Counts (Sync-StandaloneFiles `
    -FileNames @('CHANGELOG.md', 'PLANS.md', 'README.md') `
    -SourceBase $opencodeBase `
    -TargetBase $claudeBase `
    -Direction $direction -WhatIf:$WhatIf)

# ── Root Quick Start ──────────────────────────────────────────────────────────
Write-Host "`n==> Quick Start (QUICK_START_OPENCODE.md -> QUICK_START_CLAUDE.md)" -ForegroundColor Magenta
$qsc = @{ synced = 0; ok = 0; warn = 0 }
$qsc[(Sync-StandaloneFile `
    -SourceFile (Join-Path $repoRoot 'QUICK_START_OPENCODE.md') `
    -TargetFile (Join-Path $repoRoot 'QUICK_START_CLAUDE.md') `
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
