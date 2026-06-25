<#
.SYNOPSIS
    Syncs content from GitHub Copilot files (.github/) to their OpenCode counterparts (.opencode/).

.DESCRIPTION
    Covers:
      - Agents      : .github/agents/*.agent.md      → .opencode/agents/*.agent.md
      - Skills      : .github/skills/*/SKILL.md      → .opencode/skills/*/SKILL.md
      - Instructions: .github/instructions/*.md      → .opencode/instructions/*.md
      - Standalone  : CHANGELOG.md, PLANS.md, README.md  (created if absent in .opencode/)

    For structured files (agents/skills/instructions):
      Syncs both the `description` frontmatter field AND the body content.
      Platform-specific frontmatter fields (model/tools) are preserved.

    For standalone .md files:
      Full file sync with automatic path substitution (.github/ → .opencode/).

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

$repoRoot   = Split-Path $PSScriptRoot -Parent
$moduleFile = Join-Path $PSScriptRoot 'Sync-Description.psm1'

if (-not (Test-Path $moduleFile)) { Write-Error "Module not found: $moduleFile"; exit 1 }
Import-Module $moduleFile -Force

$githubBase   = Join-Path $repoRoot '.github'
$opencodeBase = Join-Path $repoRoot '.opencode'
$direction    = 'github-to-opencode'

$totalSynced = 0; $totalOk = 0; $totalWarn = 0

function Add-Counts ($counts) {
    $script:totalSynced += $counts.synced
    $script:totalOk     += $counts.ok
    $script:totalWarn   += $counts.warn
}

# ── Agents ────────────────────────────────────────────────────────────────────
Write-Host "`n==> Agents (.github/agents/ → .opencode/agents/)" -ForegroundColor Magenta
$agentFiles = Get-ChildItem (Join-Path $githubBase 'agents') -Filter '*.agent.md' -File |
              Select-Object -ExpandProperty FullName
Add-Counts (Sync-AgentFiles -SourceFiles $agentFiles `
    -SourceBase (Join-Path $githubBase 'agents') `
    -TargetBase (Join-Path $opencodeBase 'agents') `
    -Direction $direction -WhatIf:$WhatIf)

# ── Skills ────────────────────────────────────────────────────────────────────
Write-Host "`n==> Skills (.github/skills/ → .opencode/skills/)" -ForegroundColor Magenta
$skillFiles = Get-ChildItem (Join-Path $githubBase 'skills') -Filter 'SKILL.md' -Recurse -File |
              Select-Object -ExpandProperty FullName
Add-Counts (Sync-AgentFiles -SourceFiles $skillFiles `
    -SourceBase (Join-Path $githubBase 'skills') `
    -TargetBase (Join-Path $opencodeBase 'skills') `
    -Direction $direction -WhatIf:$WhatIf)

# ── Instructions ──────────────────────────────────────────────────────────────
Write-Host "`n==> Instructions (.github/instructions/ → .opencode/instructions/)" -ForegroundColor Magenta
$instrFiles = Get-ChildItem (Join-Path $githubBase 'instructions') -Filter '*.md' -File |
              Where-Object { $_.Name -notmatch '\.template\.md$' } |
              Select-Object -ExpandProperty FullName
Add-Counts (Sync-AgentFiles -SourceFiles $instrFiles `
    -SourceBase (Join-Path $githubBase 'instructions') `
    -TargetBase (Join-Path $opencodeBase 'instructions') `
    -Direction $direction -WhatIf:$WhatIf)

# ── MAINa Instructions Templates (Copy for reference) ──────────────────────
Write-Host "`n==> MAINa Instructions Templates (.github/instructions/*.template.md → .opencode/instructions/templates/)" -ForegroundColor Cyan
$templateDir = Join-Path $opencodeBase 'instructions' 'templates'
$templateFiles = Get-ChildItem (Join-Path $githubBase 'instructions') -Filter '*.template.md' -File
foreach ($file in $templateFiles) {
    $relativePath = $file.Name
    $targetPath = Join-Path $templateDir $relativePath
    
    if (-not (Test-Path $templateDir)) {
        if (-not $WhatIf) { New-Item -ItemType Directory -Path $templateDir -Force | Out-Null }
        Write-Host "  [MKDIR] $templateDir" -ForegroundColor Blue
    }
    
    if ($WhatIf) {
        Write-Host "  [COPY] $($file.FullName) → $targetPath" -ForegroundColor Cyan
    } else {
        Copy-Item -Path $file.FullName -Destination $targetPath -Force
        Write-Host "  [COPY] $relativePath ✓" -ForegroundColor Green
    }
}

# ── Standalone .md files ──────────────────────────────────────────────────────
Write-Host "`n==> Standalone files (.github/ → .opencode/)" -ForegroundColor Magenta
Add-Counts (Sync-StandaloneFiles `
    -FileNames @('CHANGELOG.md', 'PLANS.md', 'README.md') `
    -SourceBase $githubBase `
    -TargetBase $opencodeBase `
    -Direction $direction -WhatIf:$WhatIf)

# ── Summary ───────────────────────────────────────────────────────────────────
$mode = if ($WhatIf) { ' (dry-run)' } else { '' }
Write-Host "`n── Summary$mode ──────────────────────────────────────────────" -ForegroundColor White
Write-Host "  [SYNC/CREATE] Updated : $totalSynced" -ForegroundColor Cyan
Write-Host "  [OK]   Already in sync: $totalOk" -ForegroundColor Green
if ($totalWarn -gt 0) {
    Write-Host "  [WARN] Skipped/missing : $totalWarn" -ForegroundColor Yellow
}
