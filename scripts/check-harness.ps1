<#
.SYNOPSIS
    Consistency checks of the multi-agent harness (AP 005 P6). Exit code 1 on any error.

.DESCRIPTION
    - Agents   : frontmatter fields, model, color, preloaded skills, no version in description,
                 body version == CHANGELOG == docs/ARCHITECTURE.md
    - Skills   : frontmatter fields, name == folder, forked skills target an existing agent, size limits
    - Sources  : no Copilot-only artifacts in .claude/ (applyTo, /fleet; .github/ in agents & skills),
                 outside <!-- copilot-only --> blocks
    - Docs     : dead relative links, hard-coded agent/skill counts that differ from reality,
                 CLAUDE.md <= 200 lines
    - Config   : settings JSON valid, hook scripts exist, .gitattributes keeps *.sh in LF
    - Plans    : every NNN_*.plan.md listed in .claude/plans/README.md
    - Copilot  : sync-claude-to-github.ps1 -Check (unless -SkipSync)
    Prints an inventory (agents, skills) at the end.

.PARAMETER SkipSync
    Skip the .github/ generation check.

.EXAMPLE
    .\scripts\check-harness.ps1
#>
[CmdletBinding()]
param([switch]$SkipSync)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$repoRoot = Split-Path $PSScriptRoot -Parent
Import-Module (Join-Path $PSScriptRoot 'Sync-Description.psm1') -Force -DisableNameChecking

$claude  = Join-Path $repoRoot '.claude'
$utf8    = New-Object System.Text.UTF8Encoding($false)
$errors  = New-Object System.Collections.Generic.List[string]
$warns   = New-Object System.Collections.Generic.List[string]

function Add-Err  { param([string]$Msg) $script:errors.Add($Msg) }
function Add-Warn { param([string]$Msg) $script:warns.Add($Msg) }
function Read-Text { param([string]$Path) [System.IO.File]::ReadAllText($Path, $script:utf8) }
function Get-Rel { param([string]$Path) $Path.Substring($script:repoRoot.Length).TrimStart('\', '/').Replace('\', '/') }
function Remove-CopilotOnly { param([string]$Text) [regex]::Replace($Text, '(?s)<!--\s*copilot-only.*?-->', '') }

$AgentKeys = @('name', 'description', 'tools', 'disallowedTools', 'model', 'permissionMode', 'maxTurns', 'skills',
               'mcpServers', 'hooks', 'memory', 'background', 'isolation', 'effort', 'omitClaudeMd', 'color',
               'initialPrompt', 'experimental')
$SkillKeys = @('name', 'description', 'when_to_use', 'argument-hint', 'arguments', 'disable-model-invocation',
               'user-invocable', 'allowed-tools', 'disallowed-tools', 'model', 'effort', 'context', 'agent',
               'background', 'hooks', 'paths', 'shell', 'metadata', 'license', 'compatibility')
$Colors    = @('red', 'blue', 'green', 'yellow', 'purple', 'orange', 'pink', 'cyan')
$Models    = @('opus', 'sonnet', 'haiku', 'fable', 'inherit')

function Get-ListValue {
    # YAML block list ("- a" lines) or inline list ("[a, b]" / "a, b") -> string[]
    param([string]$Raw)
    if (-not $Raw) { return @() }
    $block = @($Raw -split "`n" | Where-Object { $_ -match '^\s*-\s*\S' } | ForEach-Object { ($_ -replace '^\s*-\s*', '').Trim() })
    if ($block.Count -gt 0) { return $block }
    return @($Raw.Trim().TrimStart('[').TrimEnd(']') -split ',' | ForEach-Object { Get-ScalarValue $_ } | Where-Object { $_ })
}

# ── Agents ────────────────────────────────────────────────────────────────────
$skillNames = @(Get-ChildItem (Join-Path $claude 'skills') -Directory | Select-Object -ExpandProperty Name)
$changelog  = Read-Text (Join-Path $claude 'CHANGELOG.md')
$archDoc    = Read-Text (Join-Path $repoRoot 'docs\ARCHITECTURE.md')
$agents     = @()

foreach ($file in Get-ChildItem (Join-Path $claude 'agents') -Filter '*.agent.md' -File) {
    $rel   = Get-Rel $file.FullName
    $text  = Read-Text $file.FullName
    $parts = Split-Frontmatter $text
    if ($null -eq $parts) { Add-Err "$rel : frontmatter manquant"; continue }
    $fm    = Get-FrontmatterEntries $parts.Frontmatter
    $name  = Get-ScalarValue $fm['name']

    foreach ($k in $fm.Keys) { if ($k -notin $AgentKeys) { Add-Err "$rel : champ frontmatter non supporté '$k'" } }
    if (-not $name) { Add-Err "$rel : 'name' manquant" }
    if (-not $fm.Contains('description')) { Add-Err "$rel : 'description' manquante" }
    elseif ($fm['description'] -match '\[v\d') { Add-Err "$rel : version dans la description (la mettre dans le corps)" }
    if ($fm.Contains('color') -and (Get-ScalarValue $fm['color']) -notin $Colors) { Add-Err "$rel : couleur invalide" }
    $model = Get-ScalarValue $fm['model']
    if (-not $model) { Add-Err "$rel : 'model' manquant" }
    elseif ($model -notin $Models -and $model -notmatch '^claude-') { Add-Err "$rel : modèle inconnu '$model'" }
    if (-not $fm.Contains('tools')) { Add-Err "$rel : 'tools' manquant (aucun cloisonnement)" }
    foreach ($s in (Get-ListValue $fm['skills'])) {
        if ($s -notin $skillNames) { Add-Err "$rel : skill préchargé inexistant '$s'" }
    }

    $version = $null
    if ($parts.Body -match '>\s*\*\*Version\*\*\s*:\s*v(\d+(\.\d+)+)') { $version = $Matches[1] }
    else { Add-Err "$rel : ligne '> **Version** : vX.Y' absente du corps" }
    if ($version -and $name) {
        $section = [regex]::Match($changelog, "(?ms)^##[^\n]*\b$([regex]::Escape($name))\b.*?(?=^## |\z)").Value
        if (-not $section) { Add-Err "CHANGELOG.md : section '$name' absente" }
        elseif ($section -notmatch "(→\s*v$([regex]::Escape($version))\*\*|\*\*v$([regex]::Escape($version))\*\*)") {
            Add-Err "CHANGELOG.md : pas d'entrée pour $name v$version"
        }
        $archRow = [regex]::Match($archDoc, "``$([regex]::Escape($file.Name))``\s*\|\s*v(\d+(\.\d+)+)")
        if (-not $archRow.Success) { Add-Err "docs/ARCHITECTURE.md : agent $($file.Name) absent de la table" }
        elseif ($archRow.Groups[1].Value -ne $version) {
            Add-Err "docs/ARCHITECTURE.md : $name v$($archRow.Groups[1].Value) ≠ v$version (corps de l'agent)"
        }
    }
    $agents += [pscustomobject]@{ Name = $name; Version = $version; Model = $model; Skills = (Get-ListValue $fm['skills']) -join ', ' }
}
$agentNames = @($agents | ForEach-Object { $_.Name })

# ── Skills ────────────────────────────────────────────────────────────────────
$skills = @()
foreach ($dir in Get-ChildItem (Join-Path $claude 'skills') -Directory) {
    $path = Join-Path $dir.FullName 'SKILL.md'
    $rel  = Get-Rel $path
    if (-not (Test-Path $path)) { Add-Err "$(Get-Rel $dir.FullName) : SKILL.md manquant"; continue }
    $text  = Read-Text $path
    $parts = Split-Frontmatter $text
    if ($null -eq $parts) { Add-Err "$rel : frontmatter manquant"; continue }
    $fm = Get-FrontmatterEntries $parts.Frontmatter
    foreach ($k in $fm.Keys) { if ($k -notin $SkillKeys) { Add-Err "$rel : champ frontmatter non supporté '$k'" } }
    if ((Get-ScalarValue $fm['name']) -ne $dir.Name) { Add-Err "$rel : 'name' ≠ nom du dossier" }
    if (-not $fm.Contains('description')) { Add-Err "$rel : 'description' manquante" }
    elseif ($fm['description'].Length -gt 1536) { Add-Err "$rel : description > 1536 caractères" }
    if ($fm.Contains('context')) {
        if (-not $fm.Contains('agent')) { Add-Err "$rel : 'context: fork' sans 'agent'" }
        elseif ((Get-ScalarValue $fm['agent']) -notin $agentNames) { Add-Err "$rel : agent '$(Get-ScalarValue $fm['agent'])' inexistant" }
    }
    $lines = ($text -split "`n").Count
    if ($lines -gt 500) { Add-Warn "$rel : $lines lignes (> 500 recommandées)" }
    $mode = if ($fm.Contains('disable-model-invocation')) { 'utilisateur' } elseif ($fm.Contains('user-invocable')) { 'modèle' } else { 'les deux' }
    $skills += [pscustomobject]@{ Name = $dir.Name; Invocation = $mode }
}

# ── Copilot-only artifacts in the Claude source ──────────────────────────────
$sourceDocs = Get-ChildItem $claude -Recurse -File -Include '*.md' |
              Where-Object { $_.FullName -notmatch '[\\/]plans[\\/]' -and $_.Name -ne 'CHANGELOG.md' -and $_.Name -ne 'SKILL.copilot.md' }
foreach ($file in $sourceDocs) {
    $rel  = Get-Rel $file.FullName
    $text = Remove-CopilotOnly (Read-Text $file.FullName)
    if ($text -match 'applyTo') { Add-Err "$rel : 'applyTo' (champ Copilot) hors bloc copilot-only" }
    if ($text -match '(?<![\w-])/fleet\b') { Add-Err "$rel : '/fleet' (commande Copilot) hors bloc copilot-only" }
    if ($rel -match '^\.claude/(agents|skills)/' -and $text -match '\.github/') { Add-Err "$rel : chemin '.github/' dans une source d'agent/skill" }
}

# ── Docs: dead links, counts, size ────────────────────────────────────────────
$docFiles = @()
$docFiles += Get-ChildItem $repoRoot -File -Filter '*.md'
$docFiles += Get-ChildItem (Join-Path $repoRoot 'docs') -Recurse -File -Filter '*.md'
$docFiles += Get-ChildItem (Join-Path $repoRoot 'scripts') -Recurse -File -Filter '*.md'
$docFiles += Get-ChildItem $claude -Recurse -File -Filter '*.md' | Where-Object { $_.FullName -notmatch '[\\/]plans[\\/](archive|00[1-4])' }

$agentCount = $agents.Count
$skillCount = $skills.Count
foreach ($file in $docFiles) {
    $rel  = Get-Rel $file.FullName
    $text = Read-Text $file.FullName
    foreach ($m in [regex]::Matches($text, '\]\(([^)\s]+)\)')) {
        $target = $m.Groups[1].Value
        if ($target -match '^(https?:|mailto:|#)' -or $target -match '[\[\]<>]|NNN|<NO>') { continue }
        $target = ($target -split '#')[0]
        if (-not $target) { continue }
        $resolved = Join-Path $file.DirectoryName ([uri]::UnescapeDataString($target))
        if (-not (Test-Path $resolved)) { Add-Err "$rel : lien mort -> $target" }
    }
    if ($rel -notmatch '^(\.claude/plans/|docs/adr/)' -and $file.Name -ne 'CHANGELOG.md') {   # plans, ADR, changelog = history
        foreach ($m in [regex]::Matches($text, '\b(\d+)\s+(agents|skills)\b')) {
            $n = [int]$m.Groups[1].Value
            $expected = if ($m.Groups[2].Value -eq 'agents') { $agentCount } else { $skillCount }
            if ($n -ne $expected) { Add-Err "$rel : « $($m.Value) » codé en dur (réel : $expected)" }
        }
    }
}
$claudeMdLines = ((Read-Text (Join-Path $claude 'CLAUDE.md')) -split "`n").Count
if ($claudeMdLines -gt 200) { Add-Err ".claude/CLAUDE.md : $claudeMdLines lignes (> 200)" }
$tplLines = ((Read-Text (Join-Path $claude 'CLAUDE.template.md')) -split "`n").Count
if ($tplLines -gt 200) { Add-Warn ".claude/CLAUDE.template.md : $tplLines lignes (> 200)" }

# ── Config: settings, hooks, line endings ─────────────────────────────────────
foreach ($name in @('settings.json', 'settings.template.json')) {
    $path = Join-Path $claude $name
    if (-not (Test-Path $path)) { Add-Err ".claude/$name : absent"; continue }
    try { $json = Read-Text $path | ConvertFrom-Json } catch { Add-Err ".claude/$name : JSON invalide ($($_.Exception.Message))"; continue }
    foreach ($m in [regex]::Matches((Read-Text $path), '\.claude/hooks/([\w.-]+)')) {
        if (-not (Test-Path (Join-Path $claude "hooks\$($m.Groups[1].Value)"))) { Add-Err ".claude/$name : script de hook absent '$($m.Value)'" }
    }
}
$attrPath = Join-Path $repoRoot '.gitattributes'
if (-not (Test-Path $attrPath) -or (Read-Text $attrPath) -notmatch '(?m)^\*\.sh\s+.*eol=lf') { Add-Err ".gitattributes : '*.sh ... eol=lf' absent" }
foreach ($sh in Get-ChildItem $repoRoot -Recurse -File -Filter '*.sh' | Where-Object { $_.FullName -notmatch '[\\/](\.git|node_modules)[\\/]' }) {
    if ((Read-Text $sh.FullName).Contains("`r`n")) { Add-Err "$(Get-Rel $sh.FullName) : fins de ligne CRLF (bash les refuse)" }
}

# ── Plans index ───────────────────────────────────────────────────────────────
$plansDir = Join-Path $claude 'plans'
$index    = Read-Text (Join-Path $plansDir 'README.md')
foreach ($plan in Get-ChildItem $plansDir -File -Filter '*.plan.md') {
    if (-not $index.Contains($plan.Name)) { Add-Err ".claude/plans/README.md : plan $($plan.Name) non indexé" }
}

# ── Copilot generation ────────────────────────────────────────────────────────
if (-not $SkipSync) {
    $psExe = (Get-Process -Id $PID).Path   # same PowerShell edition, separate process -> reliable exit code
    & $psExe -NoProfile -ExecutionPolicy Bypass -File (Join-Path $PSScriptRoot 'sync-claude-to-github.ps1') -Check *> $null
    if ($LASTEXITCODE -ne 0) { Add-Err ".github/ non synchronisé avec .claude/ (lancer scripts/sync-claude-to-github.ps1)" }
}

# ── Report ────────────────────────────────────────────────────────────────────
Write-Host "`n== Inventaire" -ForegroundColor Magenta
$agents | Format-Table -AutoSize | Out-String | Write-Host
Write-Host ("Skills ({0}) : {1}" -f $skillCount, (($skills | ForEach-Object { "$($_.Name) [$($_.Invocation)]" }) -join ', '))

foreach ($w in $warns)  { Write-Host "  [WARN]  $w" -ForegroundColor Yellow }
foreach ($e in $errors) { Write-Host "  [ERROR] $e" -ForegroundColor Red }
Write-Host ("`n== {0} erreur(s), {1} avertissement(s)" -f $errors.Count, $warns.Count) -ForegroundColor $(if ($errors.Count) { 'Red' } else { 'Green' })
if ($errors.Count -gt 0) { exit 1 }
