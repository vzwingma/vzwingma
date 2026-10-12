<#
.SYNOPSIS
    Unit tests of scripts/Sync-Description.psm1 (Claude -> Copilot generator).
    No dependency (Pester not required). Exit code = number of failed assertions.

.EXAMPLE
    powershell -NoProfile -ExecutionPolicy Bypass -File scripts/tests/sync.tests.ps1
#>
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

Import-Module (Join-Path $PSScriptRoot '..\Sync-Description.psm1') -Force -DisableNameChecking

$script:pass = 0
$script:fail = 0
function Assert-Equal {
    param([string]$Label, $Expected, $Actual)
    if ("$Expected" -ceq "$Actual") { $script:pass++; Write-Host "  ok   $Label" }
    else { $script:fail++; Write-Host "  FAIL $Label`n       expected: [$Expected]`n       actual:   [$Actual]" -ForegroundColor Red }
}
function Assert-True { param([string]$Label, [bool]$Condition) Assert-Equal $Label $true $Condition }

$nl = "`n"

Write-Host '== ConvertTo-CopilotText'
Assert-Equal 'paths .claude/ -> .github/' 'see .github/agents/' (ConvertTo-CopilotText 'see .claude/agents/')
Assert-Equal 'QUICK_START before CLAUDE.md' 'QUICK_START_COPILOT.md' (ConvertTo-CopilotText 'QUICK_START_CLAUDE.md')
Assert-Equal 'template before CLAUDE.md' 'copilot-instructions.template.md' (ConvertTo-CopilotText 'CLAUDE.template.md')
Assert-Equal 'CLAUDE.md' 'copilot-instructions.md' (ConvertTo-CopilotText 'CLAUDE.md')
Assert-Equal 'product name' 'GitHub Copilot' (ConvertTo-CopilotText 'Claude Code')
Assert-Equal 'word Claude' 'instructions Copilot' (ConvertTo-CopilotText 'instructions Claude')
Assert-Equal 'model names kept' 'Claude Sonnet 4.6, Claude Opus, Claude Haiku, Claude Fable' (ConvertTo-CopilotText 'Claude Sonnet 4.6, Claude Opus, Claude Haiku, Claude Fable')
Assert-Equal 'identifiers kept' 'ClaudeX claude --agent .claude' (ConvertTo-CopilotText 'ClaudeX claude --agent .claude')
Assert-Equal 'claude-only block removed' "A${nl}D" (ConvertTo-CopilotText "A${nl}<!-- claude-only -->${nl}B${nl}C${nl}<!-- /claude-only -->${nl}D")
Assert-Equal 'claude-only inline removed' "A B${nl}C" (ConvertTo-CopilotText "A<!-- claude-only --> x<!-- /claude-only --> B${nl}C")
Assert-Equal 'copilot-only unwrapped' "A${nl}Use /fleet${nl}B" (ConvertTo-CopilotText "A${nl}<!-- copilot-only${nl}Use /fleet${nl}-->${nl}B")
Assert-Equal 'copilot-only content substituted' 'read .github/instructions/dev.instructions.md' (ConvertTo-CopilotText '<!-- copilot-only read .claude/instructions/dev.instructions.md -->')

Write-Host '== ConvertTo-CopilotToolList'
Assert-Equal 'comma string + map' '[Read, Grep, agent, todo]' (ConvertTo-CopilotToolList -Raw 'Read, Grep, Agent, TaskCreate, TaskUpdate' -ToolMap @{ Agent = 'agent'; TaskCreate = 'todo'; TaskUpdate = 'todo' })
Assert-Equal 'inline list' '[Read, Edit]' (ConvertTo-CopilotToolList -Raw '[Read, Edit]')

Write-Host '== Get-FrontmatterEntries'
$fm = Get-FrontmatterEntries "---${nl}name: X${nl}skills:${nl}  - a${nl}  - b${nl}description: `"d`"${nl}---"
Assert-Equal 'keys in order' 'name,skills,description' ($fm.Keys -join ',')
Assert-Equal 'block value kept' "${nl}  - a${nl}  - b" $fm['skills']

Write-Host '== New-CopilotAgentContent'
$agent = "---${nl}name: DEVon${nl}description: `"Implémente avec Claude Code`"${nl}model: sonnet${nl}color: blue${nl}tools: Read, Edit, Agent${nl}skills:${nl}  - plan-phase-execution${nl}hooks: {}${nl}---${nl}${nl}Voir .claude/PLANS.md${nl}"
$mapping = @{ ModelMap = @{ sonnet = 'Claude Sonnet 4.6 (copilot)' }; ToolMap = @{ Agent = 'agent' }; Agents = @{} }
$out = New-CopilotAgentContent -SourceContent $agent -Mapping $mapping
Assert-True 'description substituted' ($out -match 'description: "Implémente avec GitHub Copilot"')
Assert-True 'model derived from ModelMap' ($out -match "(?m)^model: Claude Sonnet 4\.6 \(copilot\)$")
Assert-True 'tools derived + mapped' ($out -match '(?m)^tools: \[Read, Edit, agent\]$')
Assert-True 'Claude-only fields dropped' (-not ($out -match '(?m)^(color|skills|hooks):'))
Assert-True 'body substituted' ($out -match 'Voir \.github/PLANS\.md')
$mapping.Agents = @{ DEVon = @{ model = 'GPT-5 (copilot)'; tools = '[read]'; agents = '["QALvin"]' } }
$out = New-CopilotAgentContent -SourceContent $agent -Mapping $mapping
Assert-True 'override model wins' ($out -match '(?m)^model: GPT-5 \(copilot\)$')
Assert-True 'override tools wins' ($out -match '(?m)^tools: \[read\]$')
Assert-True 'override agents emitted' ($out -match '(?m)^agents: \["QALvin"\]$')
Assert-Equal 'field order' 'description,name,model,agents,tools' ((Get-FrontmatterEntries (Split-Frontmatter $out).Frontmatter).Keys -join ',')

Write-Host '== New-CopilotSkillContent'
$skill = "---${nl}name: devon${nl}description: `"Lance DEVon (Claude)`"${nl}disable-model-invocation: true${nl}context: fork${nl}agent: DEVon${nl}license: MIT${nl}---${nl}Body .claude/x${nl}"
$out = New-CopilotSkillContent -SourceContent $skill
Assert-Equal 'only spec keys kept' 'name,description,license' ((Get-FrontmatterEntries (Split-Frontmatter $out).Frontmatter).Keys -join ',')
Assert-True 'skill description substituted' ($out -match 'description: "Lance DEVon \(Copilot\)"')
Assert-True 'skill body substituted' ($out -match 'Body \.github/x')

Write-Host '== New-CopilotInstructionContent'
$conv = "---${nl}name: conventions-dev${nl}description: `"Conventions DEVon`"${nl}user-invocable: false${nl}---${nl}# Conventions${nl}"
$out = New-CopilotInstructionContent -SourceContent $conv
Assert-Equal 'instruction frontmatter' 'description,applyTo' ((Get-FrontmatterEntries (Split-Frontmatter $out).Frontmatter).Keys -join ',')
Assert-True 'applyTo all' ($out -match '(?m)^applyTo: "\*\*"$')

Write-Host '== CRLF preserved'
$crlf = "---`r`nname: a`r`ndescription: `"d`"`r`n---`r`nBody`r`n"
$out = New-CopilotSkillContent -SourceContent $crlf
Assert-True 'CRLF kept in frontmatter' ($out.StartsWith("---`r`nname: a`r`n"))

Write-Host ("== {0} passed, {1} failed" -f $script:pass, $script:fail)
exit $script:fail
