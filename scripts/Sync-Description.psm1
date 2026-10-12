<#
.SYNOPSIS
    Generates GitHub Copilot files (.github/) from Claude Code files (.claude/), the single
    source of truth (ADR 003). One direction only: claude -> github.

    - Agents : Copilot frontmatter generated (name + description from .claude/, model/tools/agents
               from scripts/copilot-mapping.psd1 or derived from Claude model/tools). Claude-only
               fields (permissionMode, skills, hooks, memory, ...) are dropped.
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

    $r = [regex]::Replace($Content, '(?s)[ \t]*<!--\s*claude-only\s*-->.*?<!--\s*/claude-only\s*-->[ \t]*(\r?\n)?', '')
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
    #>
    param([Parameter(Mandatory)][string]$Raw, [hashtable]$ToolMap = @{})

    $items = $Raw.Trim().TrimStart('[').TrimEnd(']') -split ',' |
             ForEach-Object { Get-ScalarValue $_ } |
             Where-Object { $_ }
    $mapped = foreach ($tool in $items) {
        if ($ToolMap.ContainsKey($tool)) { $ToolMap[$tool] } else { $tool }
    }
    return '[' + (($mapped | Select-Object -Unique) -join ', ') + ']'
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
        $out['tools'] = ConvertTo-CopilotToolList -Raw $src['tools'] -ToolMap $toolMap
    }

    foreach ($key in ($ov.Keys | Sort-Object)) {
        if (-not $out.Contains($key)) { $out[$key] = $ov[$key] }
    }

    return (ConvertTo-FrontmatterBlock -Entries $out -Newline $nl) + (ConvertTo-CopilotText $parts.Body)
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
    Split-Frontmatter, Get-FrontmatterEntries, Get-ScalarValue, `
    ConvertTo-CopilotText, ConvertTo-CopilotToolList, `
    New-CopilotAgentContent, New-CopilotSkillContent, `
    Write-GeneratedFile, Sync-AgentFile, Sync-SkillFile, Sync-StandaloneFile
