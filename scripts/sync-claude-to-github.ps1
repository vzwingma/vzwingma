<#
.SYNOPSIS
    Generates GitHub Copilot files (.github/) from Claude Code files (.claude/).

.DESCRIPTION
    .claude/ is the single source of truth (ADR 003). This is the only sync direction.

    Covers:
      - Agents      : .claude/agents/*.agent.md        -> .github/agents/*.agent.md  (Copilot frontmatter generated)
      - Agents index: .claude/agents/README.md          -> .github/agents/README.md
      - Skills      : .claude/skills/<name>/**          -> .github/skills/<name>/**   (SKILL.md frontmatter reduced to spec)
      - Instructions: .claude/instructions/*.md         -> .github/instructions/*.md
      - Prompts     : .claude/prompts/*.prompt.md       -> .github/prompts/*.prompt.md
      - Root        : .claude/CLAUDE.md                 -> .github/copilot-instructions.md
                      .claude/CLAUDE.template.md        -> .github/copilot-instructions.template.md
      - Standalone  : CHANGELOG.md, PLANS.md, README.md
      - Quick Start : QUICK_START_CLAUDE.md             -> QUICK_START_COPILOT.md

    Copilot-only frontmatter (model, tools, agents) comes from scripts/copilot-mapping.psd1.
    Files present in .github/ without a .claude/ source are reported as orphans (never deleted).

.PARAMETER WhatIf
    Dry-run: shows what would change without writing any files.

.PARAMETER Check
    CI mode: dry-run, exits with code 1 if anything would change or orphans exist.

.EXAMPLE
    .\sync-claude-to-github.ps1
    .\sync-claude-to-github.ps1 -WhatIf
    .\sync-claude-to-github.ps1 -Check
#>
[CmdletBinding()]
param(
    [switch]$WhatIf,
    [switch]$Check
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
if ($Check) { $WhatIf = $true }

$repoRoot    = Split-Path $PSScriptRoot -Parent
$moduleFile  = Join-Path $PSScriptRoot 'Sync-Description.psm1'
$mappingFile = Join-Path $PSScriptRoot 'copilot-mapping.psd1'

foreach ($f in @($moduleFile, $mappingFile)) {
    if (-not (Test-Path $f)) { Write-Error "Missing file: $f"; exit 1 }
}
Import-Module $moduleFile -Force -DisableNameChecking
$mapping = Import-PowerShellDataFile $mappingFile

$claudeBase = Join-Path $repoRoot '.claude'
$githubBase = Join-Path $repoRoot '.github'

$counts   = @{ synced = 0; ok = 0; warn = 0 }
$expected = New-Object System.Collections.Generic.HashSet[string]([System.StringComparer]::OrdinalIgnoreCase)

function Register-Result {
    param([string]$Result, [string]$TargetFile)
    $script:counts[$Result]++
    [void]$script:expected.Add([System.IO.Path]::GetFullPath($TargetFile))
}

function Get-RelativePath {
    param([string]$Base, [string]$Path)
    return $Path.Substring($Base.Length).TrimStart('\', '/')
}

# ── Agents ────────────────────────────────────────────────────────────────────
Write-Host "`n==> Agents (.claude/agents/ -> .github/agents/)" -ForegroundColor Magenta
foreach ($file in Get-ChildItem (Join-Path $claudeBase 'agents') -Filter '*.agent.md' -File) {
    $target = Join-Path (Join-Path $githubBase 'agents') $file.Name
    Register-Result (Sync-AgentFile -SourceFile $file.FullName -TargetFile $target -Mapping $mapping -WhatIf:$WhatIf) $target
}
$agentsIndex = Join-Path $claudeBase 'agents\README.md'
if (Test-Path $agentsIndex) {
    $target = Join-Path $githubBase 'agents\README.md'
    Register-Result (Sync-StandaloneFile -SourceFile $agentsIndex -TargetFile $target -WhatIf:$WhatIf) $target
}

# ── Skills (SKILL.md + supporting files) ─────────────────────────────────────
Write-Host "`n==> Skills (.claude/skills/ -> .github/skills/)" -ForegroundColor Magenta
$skillsBase = Join-Path $claudeBase 'skills'
foreach ($file in Get-ChildItem $skillsBase -Recurse -File) {
    $target = Join-Path (Join-Path $githubBase 'skills') (Get-RelativePath $skillsBase $file.FullName)
    if ($file.Name -eq 'SKILL.md') {
        $result = Sync-SkillFile -SourceFile $file.FullName -TargetFile $target -WhatIf:$WhatIf
    } else {
        $result = Sync-StandaloneFile -SourceFile $file.FullName -TargetFile $target -WhatIf:$WhatIf
    }
    Register-Result $result $target
}

# ── Instructions + prompts (full-file substitution) ───────────────────────────
foreach ($dir in @(@{ Name = 'instructions'; Filter = '*.md' }, @{ Name = 'prompts'; Filter = '*.prompt.md' })) {
    Write-Host "`n==> $($dir.Name) (.claude/$($dir.Name)/ -> .github/$($dir.Name)/)" -ForegroundColor Magenta
    $srcDir = Join-Path $claudeBase $dir.Name
    if (-not (Test-Path $srcDir)) { Write-Host "  [OK]     nothing to sync" -ForegroundColor Green; continue }
    foreach ($file in Get-ChildItem $srcDir -Filter $dir.Filter -File) {
        $target = Join-Path (Join-Path $githubBase $dir.Name) $file.Name
        Register-Result (Sync-StandaloneFile -SourceFile $file.FullName -TargetFile $target -WhatIf:$WhatIf) $target
    }
}

# ── Root files ────────────────────────────────────────────────────────────────
Write-Host "`n==> Root files (.claude/ -> .github/, quick start)" -ForegroundColor Magenta
$rootMap = @(
    @{ Source = Join-Path $claudeBase 'CLAUDE.md';          Target = Join-Path $githubBase 'copilot-instructions.md' }
    @{ Source = Join-Path $claudeBase 'CLAUDE.template.md'; Target = Join-Path $githubBase 'copilot-instructions.template.md' }
    @{ Source = Join-Path $claudeBase 'CHANGELOG.md';       Target = Join-Path $githubBase 'CHANGELOG.md' }
    @{ Source = Join-Path $claudeBase 'PLANS.md';           Target = Join-Path $githubBase 'PLANS.md' }
    @{ Source = Join-Path $claudeBase 'README.md';          Target = Join-Path $githubBase 'README.md' }
    @{ Source = Join-Path $repoRoot 'QUICK_START_CLAUDE.md'; Target = Join-Path $repoRoot 'QUICK_START_COPILOT.md' }
)
foreach ($m in $rootMap) {
    Register-Result (Sync-StandaloneFile -SourceFile $m.Source -TargetFile $m.Target -WhatIf:$WhatIf) $m.Target
}

# ── Orphans (generated tree only, never deleted) ──────────────────────────────
Write-Host "`n==> Orphans (.github/ files without .claude/ source)" -ForegroundColor Magenta
$orphans = @()
foreach ($sub in @('agents', 'skills', 'instructions', 'prompts')) {
    $dir = Join-Path $githubBase $sub
    if (-not (Test-Path $dir)) { continue }
    foreach ($file in Get-ChildItem $dir -Recurse -File) {
        if (-not $expected.Contains([System.IO.Path]::GetFullPath($file.FullName))) { $orphans += $file.FullName }
    }
}
if ($orphans.Count -eq 0) {
    Write-Host "  [OK]     none" -ForegroundColor Green
} else {
    $orphans | ForEach-Object { Write-Host "  [ORPHAN] $_" -ForegroundColor Yellow }
}

# ── Summary ───────────────────────────────────────────────────────────────────
$mode = if ($WhatIf) { ' (dry-run)' } else { '' }
Write-Host "`n-- Summary$mode --------------------------------------------" -ForegroundColor White
Write-Host "  [SYNC/CREATE] Updated : $($counts.synced)" -ForegroundColor Cyan
Write-Host "  [OK]   Already in sync: $($counts.ok)" -ForegroundColor Green
if ($counts.warn -gt 0) { Write-Host "  [WARN] Missing source : $($counts.warn)" -ForegroundColor Yellow }
if ($orphans.Count -gt 0) { Write-Host "  [ORPHAN] Orphans      : $($orphans.Count)" -ForegroundColor Yellow }

if ($Check -and ($counts.synced -gt 0 -or $counts.warn -gt 0 -or $orphans.Count -gt 0)) {
    Write-Host "`nCheck failed: .github/ is not in sync with .claude/" -ForegroundColor Red
    exit 1
}
