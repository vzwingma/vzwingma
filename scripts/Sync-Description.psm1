<#
.SYNOPSIS
    Generates GitHub Copilot files (.github/) from Claude Code files (.claude/), the single
    source of truth (ADR 003). One direction only: claude -> github.

    - Agents : Copilot frontmatter generated (name + description from .claude/, model/tools/agents
               from scripts/copilot-mapping.psd1 or derived from Claude model/tools; unmapped Claude
               tools are reported with a warning). Claude `skills:` is replaced by an explicit
               skill-loading notice at the top of the profile (conventions-<role> are pointed to as
               .github/instructions/<role>.instructions.template.md, not as skills). Other Claude-only
               fields (hooks, memory, effort, color, ...) are dropped; a missing `tools` (= all tools)
               and restrictive fields (disallowedTools, permissionMode) raise a visible warning.
    - Skills : frontmatter reduced to Agent Skills spec fields (name, description, license,
               compatibility, metadata, allowed-tools).
    - Text   : path/term substitution on delimited tokens + platform blocks:
                 <!-- claude-only --> ... <!-- /claude-only -->   removed for Copilot
                 <!-- copilot-only ... -->                        unwrapped for Copilot
#>

$script:Utf8NoBom = New-Object System.Text.UTF8Encoding($false)

# Agent Skills spec fields (agentskills.io) — the only ones kept in Copilot SKILL.md.
$script:SkillSpecKeys = @('name', 'description', 'license', 'compatibility', 'metadata', 'allowed-tools')

# ── Internal helpers ──────────────────────────────────────────────────────────

function Write-File {
    param([string]$Path, [string]$Content)
    [System.IO.File]::WriteAllText($Path, $Content, $script:Utf8NoBom)
}

function Get-Newline {
    param([string]$Content)
    if ($Content -match "`r`n") { return "`r`n" }
    return "`n"
}

function Split-Frontmatter {
    <#
    .SYNOPSIS
        Splits a file into (frontmatter, body).
        Returns @{ Frontmatter = '---\n...\n---'; Body = '\n...' } or $null if no frontmatter.
    #>
    param([string]$Content)
    if ($Content -match '(?s)^(---\r?\n.*?\r?\n---)([\s\S]*)$') {
        return @{ Frontmatter = $Matches[1]; Body = $Matches[2] }
    }
    return $null
}

function Get-FrontmatterEntries {
    <#
    .SYNOPSIS
        Parses top-level YAML keys of a frontmatter block into an ordered dictionary
        key -> raw value text. Indented continuation lines are kept with their key ("`n"-joined).
    #>
    param([Parameter(Mandatory)][string]$Frontmatter)

    $entries = [ordered]@{}
    $lines   = $Frontmatter -split "\r?\n"
    $current = $null
    foreach ($line in $lines[1..($lines.Count - 2)]) {
        if ($line -match '^([A-Za-z][\w-]*):[ \t]?(.*)$') {
            $current = $Matches[1]
            $entries[$current] = $Matches[2]
        } elseif ($null -ne $current) {
            $entries[$current] = $entries[$current] + "`n" + $line
        }
    }
    return $entries
}

function Get-ScalarValue {
    param([string]$Raw)
    if ($null -eq $Raw) { return $null }
    return $Raw.Trim().Trim('"').Trim("'")
}

function Get-FrontmatterList {
    <#
    .SYNOPSIS
        Parses a raw frontmatter list value into a string array. Accepts a block list ("`n  - a`n  - b"),
        an inline list ("[a, b]") or a comma-separated string ("a, b").
    #>
    param([AllowNull()][string]$Raw)

    if ([string]::IsNullOrWhiteSpace($Raw)) { return @() }
    $items = foreach ($line in ($Raw -split "\r?\n")) {
        $text = $line.Trim()
        if ($text -match '^-\s+(.+)$') {
            Get-ScalarValue $Matches[1]
        } elseif ($text) {
            $text.TrimStart('[').TrimEnd(']') -split ',' | ForEach-Object { Get-ScalarValue $_ }
        }
    }
    return @($items | Where-Object { $_ })
}

function ConvertTo-FrontmatterBlock {
    param([Parameter(Mandatory)]$Entries, [Parameter(Mandatory)][string]$Newline)
    $lines = foreach ($key in $Entries.Keys) {
        "${key}: " + ($Entries[$key] -replace "`n", $Newline)
    }
    return '---' + $Newline + ($lines -join $Newline) + $Newline + '---'
}

# ── Text substitution ─────────────────────────────────────────────────────────

function ConvertTo-CopilotText {
    <#
    .SYNOPSIS
        Claude -> Copilot text conversion: platform blocks, then delimited path/file tokens,
        then product names. Model names (Claude Sonnet/Opus/Haiku/Fable) are left untouched.
    #>
    param([Parameter(Mandatory)][AllowEmptyString()][string]$Content)

    # Block form (markers own their lines): drop the lines. Inline form: drop the span only.
    $r = [regex]::Replace($Content, '(?ms)^[ \t]*<!--\s*claude-only\s*-->.*?<!--\s*/claude-only\s*-->[ \t]*\r?\n', '')
    $r = [regex]::Replace($r, '(?s)<!--\s*claude-only\s*-->.*?<!--\s*/claude-only\s*-->', '')
    $r = [regex]::Replace($r, '(?s)<!--\s*copilot-only\s*(.*?)\s*-->', '$1')

    # Longest tokens first: QUICK_START_CLAUDE.md and CLAUDE.template.md both contain "CLAUDE.md".
    $r = $r.Replace('.claude/', '.github/')
    $r = $r.Replace('QUICK_START_CLAUDE', 'QUICK_START_COPILOT')
    $r = $r.Replace('CLAUDE.template.md', 'copilot-instructions.template.md')
    $r = $r.Replace('CLAUDE.md', 'copilot-instructions.md')

    $r = $r.Replace('Claude Code', 'GitHub Copilot')
    $r = [regex]::Replace($r, '\bClaude\b(?!\s+(Sonnet|Opus|Haiku|Fable)\b)', 'Copilot')
    return $r
}

function ConvertTo-CopilotToolList {
    <#
    .SYNOPSIS
        Converts a Claude `tools` value ("Read, Grep" or "[Read, Grep]") into a Copilot inline list.
    .DESCRIPTION
        Legacy mode (no -DroppedTools): names missing from -ToolMap are passed through unchanged.
        Strict mode (-DroppedTools given): only names found in -ToolMap are emitted; any other name is
        dropped with a visible warning (never added silently). Names listed in -DroppedTools are
        reported with their documented reason; unknown names are reported as unmapped.
    #>
    param(
        [Parameter(Mandatory)][string]$Raw,
        [hashtable]$ToolMap = @{},
        [hashtable]$DroppedTools,
        [string]$AgentName = ''
    )

    $strict = $PSBoundParameters.ContainsKey('DroppedTools')
    $items  = Get-FrontmatterList $Raw
    $mapped = foreach ($tool in $items) {
        if ($ToolMap.ContainsKey($tool)) {
            $ToolMap[$tool]
        } elseif (-not $strict) {
            $tool
        } elseif ($DroppedTools.ContainsKey($tool)) {
            Write-Warning "Agent '$AgentName': Claude tool '$tool' not projected to Copilot ($($DroppedTools[$tool]))."
        } else {
            Write-Warning "Agent '$AgentName': Claude tool '$tool' has no Copilot mapping (declare it in ToolMap or DroppedTools); not emitted."
        }
    }
    return '[' + (($mapped | Select-Object -Unique) -join ', ') + ']'
}

function Remove-PrechargedWording {
    <#
    .SYNOPSIS
        Copilot CLI loads skills on relevance, not by deterministic preloading: removes the
        "preloaded" wording (Claude `skills:` semantics) from Copilot agent text.
    #>
    param([Parameter(Mandatory)][AllowEmptyString()][string]$Content)

    # Non-ASCII characters are written as \u escapes: the module file has no BOM (Windows PowerShell 5.1 safe).
    $r = [regex]::Replace($Content, '(?i)\(\s*pr\u00e9charg\u00e9(e?s?)\s*\)', '(' + [char]0x00e0 + ' charger)')
    $r = [regex]::Replace($r, '(?i)\bpr\u00e9chargement(s?)\b', 'chargement$1')
    $r = [regex]::Replace($r, '(?i)\bpr\u00e9charg\u00e9(e?s?)\b', 'charg' + [char]0x00e9 + '$1')
    return $r
}

function New-SkillLoadingNotice {
    <#
    .SYNOPSIS
        Explicit skill-loading instruction placed at the top of a Copilot agent profile
        (replaces the Claude `skills:` field, which Copilot CLI does not support deterministically).
    .DESCRIPTION
        `conventions-<role>` skills are NOT projected as skills by sync-claude-to-github.ps1: they are
        rendered as .github/instructions/<role>.instructions.template.md. They are therefore excluded from
        the skill list and replaced by a pointer to that generated file (same naming as the sync script).
        The SKILL.md fallback deliberately carries no path: Copilot CLI is only proven to list
        .claude/skills/*/SKILL.md (Phase 1 R1), not .github/skills/.
    #>
    param([Parameter(Mandatory)][string[]]$Skills)

    $conventionRoles = @($Skills | Where-Object { $_ -like 'conventions-*' } | ForEach-Object { $_.Substring('conventions-'.Length) })
    $plainSkills     = @($Skills | Where-Object { $_ -notlike 'conventions-*' })

    $role = 'r' + [char]0x00f4 + 'le'
    $gene = 'g' + [char]0x00e9 + 'n' + [char]0x00e9 + 'riques'
    $text = '> **Chargement des skills (obligatoire)** : Copilot CLI charge les skills selon leur pertinence, sans garantie par ' + $role + '. '

    if ($plainSkills.Count -gt 0) {
        $list = ($plainSkills | ForEach-Object { '`' + $_ + '`' }) -join ', '
        $text += 'Avant toute action, charge explicitement les skills suivantes (invoque la skill de ce nom ; ' +
                 'si l''invocation est indisponible, lis le fichier `SKILL.md` de cette skill) : ' + $list + '.'
    }
    if ($conventionRoles.Count -gt 0) {
        $files = ($conventionRoles | ForEach-Object { '`.github/instructions/' + $_ + '.instructions.template.md`' }) -join ', '
        if ($plainSkills.Count -gt 0) { $text += ' ' }
        $text += 'Avant toute action, lis aussi les conventions ' + $gene + ' du ' + $role + ' (fichier d''instructions, pas une skill) : ' + $files + '.'
    }
    return $text
}

# ── Generators ────────────────────────────────────────────────────────────────

function New-CopilotAgentContent {
    <#
    .SYNOPSIS
        Builds a Copilot *.agent.md from a Claude agent file content.
        Field precedence: per-agent override (mapping) > derived from Claude > omitted.
    #>
    param(
        [Parameter(Mandatory)][string]$SourceContent,
        [Parameter(Mandatory)][hashtable]$Mapping
    )

    $nl    = Get-Newline $SourceContent
    $parts = Split-Frontmatter $SourceContent
    if ($null -eq $parts) { throw 'Agent file has no frontmatter' }

    $src  = Get-FrontmatterEntries $parts.Frontmatter
    $name = Get-ScalarValue $src['name']
    $ov   = @{}
    if ($Mapping.Agents -and $Mapping.Agents.ContainsKey($name)) { $ov = $Mapping.Agents[$name] }
    $modelMap = if ($Mapping.ModelMap) { $Mapping.ModelMap } else { @{} }
    $toolMap  = if ($Mapping.ToolMap)  { $Mapping.ToolMap }  else { @{} }

    $out = [ordered]@{}
    $out['description'] = ConvertTo-CopilotText $src['description']
    $out['name']        = $src['name']

    if ($ov.ContainsKey('model')) {
        $out['model'] = $ov['model']
    } elseif ($src.Contains('model') -and $modelMap.ContainsKey((Get-ScalarValue $src['model']))) {
        $out['model'] = $modelMap[(Get-ScalarValue $src['model'])]
    }

    if ($ov.ContainsKey('agents')) { $out['agents'] = $ov['agents'] }

    if ($ov.ContainsKey('tools')) {
        $out['tools'] = $ov['tools']
    } elseif ($src.Contains('tools')) {
        $toolArgs = @{ Raw = $src['tools']; ToolMap = $toolMap; AgentName = $name }
        if ($Mapping.ContainsKey('DroppedTools')) { $toolArgs['DroppedTools'] = $Mapping['DroppedTools'] }
        $out['tools'] = ConvertTo-CopilotToolList @toolArgs
    }

    foreach ($key in ($ov.Keys | Sort-Object)) {
        if (-not $out.Contains($key)) { $out[$key] = $ov[$key] }
    }

    # No silent loss: restrictive Claude settings that have no Copilot projection are reported.
    if (-not $out.Contains('tools')) {
        Write-Warning "Agent '$name': no 'tools' in Claude source nor mapping override -> Copilot profile has no 'tools' field (ALL tools available, no least privilege)."
    }
    foreach ($restrictive in @('disallowedTools', 'permissionMode')) {
        if ($src.Contains($restrictive)) {
            Write-Warning "Agent '$name': Claude field '$restrictive' ($(Get-ScalarValue $src[$restrictive])) is not projected to Copilot (restriction lost)."
        }
    }

    # Claude `skills:` (preloading) is not supported deterministically by Copilot CLI:
    # replaced by an explicit loading notice at the top of the profile; "preloaded" wording removed.
    $body   = Remove-PrechargedWording (ConvertTo-CopilotText $parts.Body)
    $skills = @(Get-FrontmatterList $src['skills'])
    if ($skills.Count -gt 0) {
        $body = $nl + $nl + (New-SkillLoadingNotice -Skills $skills) + $nl + $nl + $body.TrimStart([char[]]@("`r", "`n"))
    }

    return (ConvertTo-FrontmatterBlock -Entries $out -Newline $nl) + $body
}

function New-CopilotSkillContent {
    <#
    .SYNOPSIS
        Builds a Copilot SKILL.md from a Claude SKILL.md: frontmatter reduced to Agent Skills
        spec fields, Claude-only fields (context, agent, disable-model-invocation, ...) dropped.
    #>
    param([Parameter(Mandatory)][string]$SourceContent)

    $nl    = Get-Newline $SourceContent
    $parts = Split-Frontmatter $SourceContent
    if ($null -eq $parts) { return ConvertTo-CopilotText $SourceContent }

    $src = Get-FrontmatterEntries $parts.Frontmatter
    $out = [ordered]@{}
    foreach ($key in $src.Keys) {
        if ($script:SkillSpecKeys -contains $key) { $out[$key] = $src[$key] }
    }
    if ($out.Contains('description')) { $out['description'] = ConvertTo-CopilotText $out['description'] }

    return (ConvertTo-FrontmatterBlock -Entries $out -Newline $nl) + (ConvertTo-CopilotText $parts.Body)
}

function New-CopilotInstructionContent {
    <#
    .SYNOPSIS
        Builds a Copilot *.instructions.md from a Claude conventions skill (conventions-<role>):
        frontmatter = description + applyTo "**", body substituted.
    #>
    param([Parameter(Mandatory)][string]$SourceContent)

    $nl    = Get-Newline $SourceContent
    $parts = Split-Frontmatter $SourceContent
    if ($null -eq $parts) { throw 'Conventions skill has no frontmatter' }

    $src = Get-FrontmatterEntries $parts.Frontmatter
    $out = [ordered]@{}
    $out['description'] = ConvertTo-CopilotText $src['description']
    $out['applyTo']     = '"**"'

    return (ConvertTo-FrontmatterBlock -Entries $out -Newline $nl) + (ConvertTo-CopilotText $parts.Body)
}

# ── File writers ──────────────────────────────────────────────────────────────

function Write-GeneratedFile {
    <#
    .SYNOPSIS
        Writes generated content to a target file when it differs.
    .OUTPUTS
        'synced' or 'ok'
    #>
    param(
        [Parameter(Mandatory)][string]$TargetFile,
        [Parameter(Mandatory)][AllowEmptyString()][string]$Content,
        [switch]$WhatIf
    )

    $label = $TargetFile
    $isNew = -not (Test-Path $TargetFile)
    if (-not $isNew) {
        $current = [System.IO.File]::ReadAllText($TargetFile, $script:Utf8NoBom)
        if ($current -eq $Content) {
            Write-Host "  [OK]     $label" -ForegroundColor Green
            return 'ok'
        }
    }

    $action = if ($isNew) { 'CREATE' } else { 'SYNC' }
    if ($WhatIf) {
        Write-Host "  [WHATIF] Would $action $label" -ForegroundColor Cyan
    } else {
        $dir = Split-Path $TargetFile -Parent
        if (-not (Test-Path $dir)) { New-Item -ItemType Directory -Path $dir -Force | Out-Null }
        Write-File $TargetFile $Content
        Write-Host "  [$action] $label" -ForegroundColor Cyan
    }
    return 'synced'
}

function Sync-AgentFile {
    param(
        [Parameter(Mandatory)][string]$SourceFile,
        [Parameter(Mandatory)][string]$TargetFile,
        [Parameter(Mandatory)][hashtable]$Mapping,
        [switch]$WhatIf
    )
    $content = New-CopilotAgentContent -SourceContent ([System.IO.File]::ReadAllText($SourceFile, $script:Utf8NoBom)) -Mapping $Mapping
    return Write-GeneratedFile -TargetFile $TargetFile -Content $content -WhatIf:$WhatIf
}

function Sync-SkillFile {
    param(
        [Parameter(Mandatory)][string]$SourceFile,
        [Parameter(Mandatory)][string]$TargetFile,
        [switch]$WhatIf
    )
    $content = New-CopilotSkillContent -SourceContent ([System.IO.File]::ReadAllText($SourceFile, $script:Utf8NoBom))
    return Write-GeneratedFile -TargetFile $TargetFile -Content $content -WhatIf:$WhatIf
}

function Sync-InstructionFile {
    param(
        [Parameter(Mandatory)][string]$SourceFile,
        [Parameter(Mandatory)][string]$TargetFile,
        [switch]$WhatIf
    )
    $content = New-CopilotInstructionContent -SourceContent ([System.IO.File]::ReadAllText($SourceFile, $script:Utf8NoBom))
    return Write-GeneratedFile -TargetFile $TargetFile -Content $content -WhatIf:$WhatIf
}

function Sync-StandaloneFile {
    <#
    .SYNOPSIS
        Full-file sync with text substitution (.md) or raw copy (other extensions).
    .OUTPUTS
        'synced', 'ok', or 'warn'
    #>
    param(
        [Parameter(Mandatory)][string]$SourceFile,
        [Parameter(Mandatory)][string]$TargetFile,
        [switch]$WhatIf
    )
    if (-not (Test-Path $SourceFile)) {
        Write-Host "  [WARN]   Source not found: $SourceFile" -ForegroundColor Yellow
        return 'warn'
    }
    $raw = [System.IO.File]::ReadAllText($SourceFile, $script:Utf8NoBom)
    $content = if ($SourceFile -like '*.md') { ConvertTo-CopilotText $raw } else { $raw }
    return Write-GeneratedFile -TargetFile $TargetFile -Content $content -WhatIf:$WhatIf
}

Export-ModuleMember -Function `
    Split-Frontmatter, Get-FrontmatterEntries, Get-FrontmatterList, Get-ScalarValue, `
    ConvertTo-CopilotText, ConvertTo-CopilotToolList, Remove-PrechargedWording, New-SkillLoadingNotice, `
    New-CopilotAgentContent, New-CopilotSkillContent, New-CopilotInstructionContent, `
    Write-GeneratedFile, Sync-AgentFile, Sync-SkillFile, Sync-InstructionFile, Sync-StandaloneFile
