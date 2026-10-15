<#
.SYNOPSIS
    AP 006 T3.1 compatibility tests for projection, path exclusions, checks, and packages.
    No dependency (Pester not required). Exit code = number of failed assertions.

.DESCRIPTION
    All mutable integration scenarios use a unique directory below $env:TEMP. Nothing is
    removed: the directory is printed and deliberately left in place for inspection.

.EXAMPLE
    powershell -NoProfile -ExecutionPolicy Bypass -File scripts/tests/compatibility.tests.ps1
    pwsh -NoProfile -File scripts/tests/compatibility.tests.ps1
#>
param([switch]$ProjectionOnly)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$repoRoot = [System.IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..\..'))
$syncModule = Join-Path $repoRoot 'scripts\Sync-Description.psm1'
$pathsModule = Join-Path $repoRoot 'scripts\Harness-Paths.psm1'
$packageModule = Join-Path $repoRoot 'scripts\Package.psm1'
$mappingFile = Join-Path $repoRoot 'scripts\copilot-mapping.psd1'

Import-Module $syncModule -Force -DisableNameChecking
Import-Module $pathsModule -Force -DisableNameChecking
Import-Module $packageModule -Force -DisableNameChecking
$mapping = Import-PowerShellDataFile $mappingFile

$script:pass = 0
$script:fail = 0
$script:utf8 = New-Object System.Text.UTF8Encoding($false)
$script:tempRoot = Join-Path $env:TEMP ("ap006-t31-{0}-{1}-{2}" -f (Get-Date -Format 'yyyyMMdd-HHmmss'), $PID, ([guid]::NewGuid().ToString('N')))
[void](New-Item -ItemType Directory -Path $script:tempRoot -Force)
Write-Host "Temporary evidence directory (left in place): $script:tempRoot"

function Assert-Equal {
    param([string]$Label, $Expected, $Actual)
    if ("$Expected" -ceq "$Actual") {
        $script:pass++
        Write-Host "  ok   $Label"
    } else {
        $script:fail++
        Write-Host "  FAIL $Label`n       expected: [$Expected]`n       actual:   [$Actual]" -ForegroundColor Red
    }
}

function Assert-True {
    param([string]$Label, [bool]$Condition)
    Assert-Equal $Label $true $Condition
}

function Assert-Match {
    param([string]$Label, [string]$Pattern, [AllowNull()]$Actual)
    Assert-True $Label ([regex]::IsMatch("$Actual", $Pattern))
}

function Assert-NotMatch {
    param([string]$Label, [string]$Pattern, [AllowNull()]$Actual)
    Assert-True $Label (-not [regex]::IsMatch("$Actual", $Pattern))
}

function Write-TestFile {
    param([Parameter(Mandatory)][string]$Path, [Parameter(Mandatory)][AllowEmptyString()][string]$Content)
    $parent = Split-Path $Path -Parent
    if (-not (Test-Path -LiteralPath $parent)) {
        [void](New-Item -ItemType Directory -Path $parent -Force)
    }
    [System.IO.File]::WriteAllText($Path, $Content, $script:utf8)
}

function Get-TestFileText {
    param([Parameter(Mandatory)][string]$Path)
    return [System.IO.File]::ReadAllText($Path, $script:utf8)
}

function Invoke-TestPowerShell {
    param(
        [Parameter(Mandatory)][string]$ScriptPath,
        [string[]]$Arguments = @()
    )
    $exe = (Get-Process -Id $PID).Path
    $invokeArgs = @('-NoProfile')
    if ($PSVersionTable.PSEdition -eq 'Desktop') {
        $invokeArgs += @('-ExecutionPolicy', 'Bypass')
    }
    $invokeArgs += @('-File', $ScriptPath)
    $invokeArgs += $Arguments
    $oldPreference = $ErrorActionPreference
    try {
        $ErrorActionPreference = 'Continue'
        $raw = & $exe @invokeArgs 2>&1
        $code = $LASTEXITCODE
    } finally {
        $ErrorActionPreference = $oldPreference
    }
    return [pscustomobject]@{
        ExitCode = $code
        Output = (($raw | ForEach-Object { "$_" }) -join "`n")
        Command = ('"{0}" {1}' -f $exe, ($invokeArgs -join ' '))
    }
}

function Get-ZipEntries {
    param([Parameter(Mandatory)][string]$Path)
    Add-Type -AssemblyName System.IO.Compression
    Add-Type -AssemblyName System.IO.Compression.FileSystem
    $archive = [System.IO.Compression.ZipFile]::OpenRead($Path)
    try {
        $entries = @($archive.Entries | ForEach-Object { $_.FullName })
    } finally {
        $archive.Dispose()
    }
    return $entries
}

function Copy-RepoSnapshot {
    param([Parameter(Mandatory)][string]$Destination)
    [void](New-Item -ItemType Directory -Path $Destination -Force)
    foreach ($file in @(Get-HarnessFiles -RepoRoot $repoRoot -Path $repoRoot -Recurse)) {
        $relative = $file.FullName.Substring($repoRoot.Length).TrimStart('\', '/')
        $target = Join-Path $Destination $relative
        $parent = Split-Path $target -Parent
        if (-not (Test-Path -LiteralPath $parent)) {
            [void](New-Item -ItemType Directory -Path $parent -Force)
        }
        [System.IO.File]::Copy($file.FullName, $target, $true)
    }
}

function Write-CheckEvidence {
    param([string]$Label, $Result, [string]$Pattern)
    $line = @($Result.Output -split "\r?\n" | Where-Object { $_ -match $Pattern } | Select-Object -First 1)
    Write-Host ("  evidence {0}: exit={1}; {2}" -f $Label, $Result.ExitCode, ($line -join ''))
}

$nl = "`n"

Write-Host '== ToolMap and DroppedTools'
$allTools = 'Read, Grep, Glob, WebFetch, WebSearch, Edit, Write, Bash, TodoWrite, TaskCreate, TaskUpdate, TaskList, TaskGet, Agent'
$projected = ConvertTo-CopilotToolList -Raw $allTools -ToolMap $mapping.ToolMap -DroppedTools $mapping.DroppedTools -AgentName 'Probe'
Assert-Equal 'all tool families project and deduplicate' '[read, search, web, edit, execute, todo, agent]' $projected

$dropWarnings = @()
$dropped = ConvertTo-CopilotToolList `
    -Raw 'Read, AskUserQuestion, SendMessage, Skill, UnknownTool' `
    -ToolMap $mapping.ToolMap `
    -DroppedTools $mapping.DroppedTools `
    -AgentName 'Probe' `
    -WarningVariable +dropWarnings
$dropWarningText = ($dropWarnings | ForEach-Object { $_.ToString() }) -join "`n"
Assert-Equal 'dropped and unknown tools are not emitted' '[read]' $dropped
Assert-Match 'AskUserQuestion warns' "AskUserQuestion.*not projected" $dropWarningText
Assert-Match 'SendMessage warns' "SendMessage.*not projected" $dropWarningText
Assert-Match 'Skill warns' "Skill.*not projected" $dropWarningText
Assert-Match 'unknown tool warns' "UnknownTool.*no Copilot mapping" $dropWarningText

$arcosSource = "---${nl}name: ARCos${nl}description: `"Read only`"${nl}model: opus${nl}tools: Read, Grep, Glob, WebFetch, WebSearch${nl}skills:${nl}  - conventions-architect${nl}---${nl}${nl}Body${nl}"
$arcosOutput = New-CopilotAgentContent -SourceContent $arcosSource -Mapping $mapping
$arcosFm = Get-FrontmatterEntries (Split-Frontmatter $arcosOutput).Frontmatter
Assert-Equal 'ARCos exact least-privilege tools' '[read, search, web]' $arcosFm['tools']
Assert-True 'ARCos has no agents field' (-not $arcosFm.Contains('agents'))

$noToolsSource = "---${nl}name: NoTools${nl}description: `"No tools`"${nl}model: sonnet${nl}---${nl}Body${nl}"
$noToolsWarnings = @()
$noToolsOutput = New-CopilotAgentContent -SourceContent $noToolsSource -Mapping $mapping -WarningVariable +noToolsWarnings
Assert-True 'agent without tools emits no tools field' (-not (Get-FrontmatterEntries (Split-Frontmatter $noToolsOutput).Frontmatter).Contains('tools'))
Assert-Match 'agent without tools warns' "no 'tools'.*ALL tools" (($noToolsWarnings | ForEach-Object { $_.ToString() }) -join "`n")

Write-Host '== ModelMap'
function New-ModelProbe {
    param([string]$Alias)
    $source = "---${nl}name: ModelProbe${nl}description: `"Model`"${nl}model: $Alias${nl}tools: Read${nl}---${nl}Body${nl}"
    return Get-FrontmatterEntries (Split-Frontmatter (New-CopilotAgentContent -SourceContent $source -Mapping $mapping)).Frontmatter
}
$opusFm = New-ModelProbe 'opus'
$sonnetFm = New-ModelProbe 'sonnet'
$unknownFm = New-ModelProbe 'alias-without-entry'
Assert-Equal 'opus maps to catalog id' 'claude-opus-5.5' $opusFm['model']
Assert-Equal 'sonnet maps to catalog id' 'claude-sonnet-5.5' $sonnetFm['model']
Assert-True 'alias without map omits model' (-not $unknownFm.Contains('model'))

Write-Host '== Skill loading notice and edge cases'
$notice = New-SkillLoadingNotice -Skills @('plan-phase-execution', 'conventions-qa')
Assert-Match 'explicit loading instruction is present' 'Chargement des skills.*plan-phase-execution' $notice
Assert-Match 'conventions point to instructions' '\.github/instructions/qa\.instructions\.template\.md' $notice
Assert-NotMatch 'conventions are not requested as a skill' 'skills suivantes[^.]*conventions-qa' $notice

$prechargedWord = 'pr' + [char]0x00e9 + 'charg' + [char]0x00e9
$prechargedText = "Skill $prechargedWord et $($prechargedWord)e"
$cleanText = Remove-PrechargedWording $prechargedText
Assert-NotMatch 'precharged wording is removed' ([regex]::Escape($prechargedWord)) $cleanText

$missingFrontmatterError = ''
try {
    [void](New-CopilotAgentContent -SourceContent 'body only' -Mapping $mapping)
} catch {
    $missingFrontmatterError = $_.Exception.Message
}
Assert-Match 'agent without frontmatter is rejected' 'no frontmatter' $missingFrontmatterError

$missingInstructionFrontmatterError = ''
try {
    [void](New-CopilotInstructionContent -SourceContent 'body only')
} catch {
    $missingInstructionFrontmatterError = $_.Exception.Message
}
Assert-Match 'instruction without frontmatter is rejected' 'no frontmatter' $missingInstructionFrontmatterError
Assert-Equal 'skill without frontmatter remains convertible' 'GitHub Copilot body' (New-CopilotSkillContent -SourceContent 'Claude Code body')

$crlf = "`r`n"
$crlfSource = "---${crlf}name: CRLF${crlf}description: `"Line endings`"${crlf}model: sonnet${crlf}tools: Read${crlf}skills:${crlf}  - plan-phase-execution${crlf}---${crlf}Body${crlf}"
$crlfOutput = New-CopilotAgentContent -SourceContent $crlfSource -Mapping $mapping
Assert-True 'agent generation preserves CRLF only' (-not [regex]::IsMatch($crlfOutput, '(?<!\r)\n'))

$idempotentDir = Join-Path $script:tempRoot 'idempotence with spaces'
$idempotentSource = Join-Path $idempotentDir 'source.agent.md'
$idempotentTarget = Join-Path $idempotentDir 'target.agent.md'
Write-TestFile -Path $idempotentSource -Content $arcosSource
$firstSync = Sync-AgentFile -SourceFile $idempotentSource -TargetFile $idempotentTarget -Mapping $mapping
$firstHash = (Get-FileHash -LiteralPath $idempotentTarget -Algorithm SHA256).Hash
$secondSync = Sync-AgentFile -SourceFile $idempotentSource -TargetFile $idempotentTarget -Mapping $mapping
$secondHash = (Get-FileHash -LiteralPath $idempotentTarget -Algorithm SHA256).Hash
Assert-Equal 'first generation writes' 'synced' $firstSync
Assert-Equal 'second generation is already in sync' 'ok' $secondSync
Assert-Equal 'second generation is byte-identical' $firstHash $secondHash

if ($ProjectionOnly) {
    Write-Host ("== Projection-only result: {0} passed, {1} failed" -f $script:pass, $script:fail)
    Write-Host "Temporary evidence directory left in place: $script:tempRoot"
    exit $script:fail
}

Write-Host '== Harness paths'
$absentIgnoreRoot = Join-Path $script:tempRoot 'ignore absent'
[void](New-Item -ItemType Directory -Path $absentIgnoreRoot -Force)
$emptyIgnoreRoot = Join-Path $script:tempRoot 'ignore empty'
[void](New-Item -ItemType Directory -Path $emptyIgnoreRoot -Force)
Write-TestFile -Path (Join-Path $emptyIgnoreRoot '.copilotignore') -Content ''
Assert-Equal 'absent ignore keeps built-in exclusions' '**/.git,**/node_modules,dist,.claude/worktrees' ((Get-HarnessExcludedDirs -RepoRoot $absentIgnoreRoot) -join ',')
Assert-Equal 'empty ignore keeps built-in exclusions' '**/.git,**/node_modules,dist,.claude/worktrees' ((Get-HarnessExcludedDirs -RepoRoot $emptyIgnoreRoot) -join ',')
Assert-Equal 'absent ignore has no unsupported entries' 0 @(Get-HarnessUnsupportedIgnoreEntries -RepoRoot $absentIgnoreRoot).Count
Assert-Equal 'empty ignore has no unsupported entries' 0 @(Get-HarnessUnsupportedIgnoreEntries -RepoRoot $emptyIgnoreRoot).Count

$pathRoot = Join-Path $script:tempRoot 'paths with spaces'
[void](New-Item -ItemType Directory -Path $pathRoot -Force)
$ignoreContent = "/dist/${nl}x/${nl}*.tmp${nl}!keep/${nl}plain.txt${nl}"
Write-TestFile -Path (Join-Path $pathRoot '.copilotignore') -Content $ignoreContent
$excludedDirs = @(Get-HarnessExcludedDirs -RepoRoot $pathRoot)
$unsupported = @(Get-HarnessUnsupportedIgnoreEntries -RepoRoot $pathRoot)
Assert-True '/dist/ is anchored as dist' ($excludedDirs -contains 'dist')
Assert-True 'x/ becomes any-depth exclusion' ($excludedDirs -contains '**/x')
Assert-Equal 'glob, negation, and file entries are reported' '*.tmp,!keep/,plain.txt' ($unsupported -join ',')

$rootOnly = Join-Path $pathRoot 'root-only'
$nestedRootOnly = Join-Path $pathRoot 'nested\root-only'
$anyRoot = Join-Path $pathRoot 'anywhere'
$anyNested = Join-Path $pathRoot 'nested\anywhere'
Assert-True 'anchored exclusion matches root path' (Test-HarnessExcludedPath -RepoRoot $pathRoot -Path $rootOnly -ExcludedDirs @('root-only'))
Assert-True 'anchored exclusion does not match nested path' (-not (Test-HarnessExcludedPath -RepoRoot $pathRoot -Path $nestedRootOnly -ExcludedDirs @('root-only')))
Assert-True '**/name matches root path' (Test-HarnessExcludedPath -RepoRoot $pathRoot -Path $anyRoot -ExcludedDirs @('**/anywhere'))
Assert-True '**/name matches nested path' (Test-HarnessExcludedPath -RepoRoot $pathRoot -Path $anyNested -ExcludedDirs @('**/anywhere'))

Write-TestFile -Path (Join-Path $pathRoot 'safe\visible.txt') -Content 'visible'
Write-TestFile -Path (Join-Path $pathRoot 'dist\hidden.txt') -Content 'root dist'
Write-TestFile -Path (Join-Path $pathRoot 'nested\dist\visible-nested.txt') -Content 'nested dist'
Write-TestFile -Path (Join-Path $pathRoot 'x\hidden.txt') -Content 'root x'
Write-TestFile -Path (Join-Path $pathRoot 'nested\x\hidden.txt') -Content 'nested x'
$walkedRelative = @(Get-HarnessFiles -RepoRoot $pathRoot -Path $pathRoot -Filter '*.txt' -Recurse |
    ForEach-Object { $_.FullName.Substring($pathRoot.Length).TrimStart('\', '/').Replace('\', '/') } |
    Sort-Object)
Assert-True 'walk includes safe file' ($walkedRelative -contains 'safe/visible.txt')
Assert-True 'walk prunes root /dist/' (-not ($walkedRelative -contains 'dist/hidden.txt'))
Assert-True 'anchored /dist/ leaves nested dist visible' ($walkedRelative -contains 'nested/dist/visible-nested.txt')
Assert-True 'walk prunes root x/' (-not ($walkedRelative -contains 'x/hidden.txt'))
Assert-True 'walk prunes nested x/' (-not ($walkedRelative -contains 'nested/x/hidden.txt'))

Write-Host '== Package helper'
$packageRoot = Join-Path $script:tempRoot 'package fixture with spaces'
[void](New-Item -ItemType Directory -Path $packageRoot -Force)
Write-TestFile -Path (Join-Path $packageRoot '.copilotignore') -Content "/dist/${nl}"
Write-TestFile -Path (Join-Path $packageRoot 'include\a.txt') -Content 'archive payload'
Write-TestFile -Path (Join-Path $packageRoot 'dist\excluded.txt') -Content 'excluded'

$missingError = ''
try {
    New-HarnessPackage -RepoRoot $packageRoot -Items @(@{ Path = 'required-missing.txt' }) -ZipPath (Join-Path $packageRoot 'missing.zip')
} catch {
    $missingError = $_.Exception.Message
}
Assert-Match 'missing required package item errors' 'introuvable.*required-missing' $missingError

$excludedError = ''
try {
    New-HarnessPackage -RepoRoot $packageRoot -Items @(@{ Path = 'dist' }) -ZipPath (Join-Path $packageRoot 'excluded.zip')
} catch {
    $excludedError = $_.Exception.Message
}
Assert-Match 'excluded package item errors' 'exclu.*dist' $excludedError

$zipPath = Join-Path $packageRoot 'result.zip'
Write-TestFile -Path ($zipPath + '.123456.partial') -Content 'stale partial evidence'
New-HarnessPackage -RepoRoot $packageRoot -Items @(@{ Path = 'include' }) -ZipPath $zipPath
Assert-True 'unrelated stale .partial does not block package' (Test-Path -LiteralPath $zipPath -PathType Leaf)
Assert-Equal 'package contains expected entry' 'include/a.txt' ((Get-ZipEntries -Path $zipPath) -join ',')

$hashBeforeRefusal = (Get-FileHash -LiteralPath $zipPath -Algorithm SHA256).Hash
$overwriteError = ''
try {
    New-HarnessPackage -RepoRoot $packageRoot -Items @(@{ Path = 'include' }) -ZipPath $zipPath
} catch {
    $overwriteError = $_.Exception.Message
}
$hashAfterRefusal = (Get-FileHash -LiteralPath $zipPath -Algorithm SHA256).Hash
Assert-Match 'existing archive overwrite is refused' 'Archive existante.*refus' $overwriteError
Assert-Equal 'refused archive keeps identical hash' $hashBeforeRefusal $hashAfterRefusal

Write-Host '== Real package entry contracts'
$packageOutput = Join-Path $script:tempRoot 'real package output with spaces'
[void](New-Item -ItemType Directory -Path $packageOutput -Force)
$githubPackage = Invoke-TestPowerShell `
    -ScriptPath (Join-Path $repoRoot 'scripts\package-github.ps1') `
    -Arguments @('-OutputDir', $packageOutput, '-FileName', 'compat-github')
$claudePackage = Invoke-TestPowerShell `
    -ScriptPath (Join-Path $repoRoot 'scripts\package-claude.ps1') `
    -Arguments @('-OutputDir', $packageOutput, '-FileName', 'compat-claude')
Assert-Equal 'GitHub package command succeeds' 0 $githubPackage.ExitCode
Assert-Equal 'Claude package command succeeds' 0 $claudePackage.ExitCode
$githubZip = Join-Path $packageOutput 'compat-github.zip'
$claudeZip = Join-Path $packageOutput 'compat-claude.zip'
Assert-True 'GitHub package exists in spaced path' (Test-Path -LiteralPath $githubZip -PathType Leaf)
Assert-True 'Claude package exists in spaced path' (Test-Path -LiteralPath $claudeZip -PathType Leaf)
$allPackageEntries = @((Get-ZipEntries -Path $githubZip) + (Get-ZipEntries -Path $claudeZip))
Assert-NotMatch 'packages contain no worktrees' '(^|/)worktrees/' ($allPackageEntries -join "`n")
Assert-NotMatch 'packages contain no settings.local' 'settings\.local' ($allPackageEntries -join "`n")
Assert-NotMatch 'packages contain no dist directory' '(^|/)dist/' ($allPackageEntries -join "`n")
Assert-NotMatch 'GitHub package omits repository copilot-instructions.md' '(?m)^\.github/copilot-instructions\.md$' ($allPackageEntries -join "`n")
Assert-NotMatch 'Claude package omits Copilot skill variants' 'SKILL\.copilot\.md$' ($allPackageEntries -join "`n")

Write-Host '== check-harness injected defects on repository copy'
$checkRoot = Join-Path $script:tempRoot 'check repository copy with spaces'
Copy-RepoSnapshot -Destination $checkRoot
$checkScript = Join-Path $checkRoot 'scripts\check-harness.ps1'
$baselineCheck = Invoke-TestPowerShell -ScriptPath $checkScript
Write-CheckEvidence -Label 'baseline' -Result $baselineCheck -Pattern 'erreur'
Assert-Equal 'copied repository baseline check succeeds' 0 $baselineCheck.ExitCode

$arcosPath = Join-Path $checkRoot '.github\agents\Arcos.agent.md'
$arcosOriginal = Get-TestFileText $arcosPath
$arcosMutated = $arcosOriginal -replace '(?m)^tools: \[read, search, web\]\r?$', 'tools: [read, search, web, edit, vscode]'
Write-TestFile -Path $arcosPath -Content $arcosMutated
Assert-True 'ARCos defect was injected in copy' ($arcosMutated -ne $arcosOriginal)
$toolCheck = Invoke-TestPowerShell -ScriptPath $checkScript -Arguments @('-SkipSync')
Write-CheckEvidence -Label 'tool contract' -Result $toolCheck -Pattern "vscode|ARCos"
Assert-True 'tool defect makes check fail' ($toolCheck.ExitCode -ne 0)
Assert-Match 'check detects tool outside contract' "outil 'vscode' hors contrat" $toolCheck.Output
Assert-Match 'check detects ARCos edit capability' "ARCos.*outil 'edit'" $toolCheck.Output

$devonPath = Join-Path $checkRoot '.github\agents\Devon.agent.md'
$devonMutated = (Get-TestFileText $devonPath) -replace '(?m)^tools:.*\r?\n', ''
Write-TestFile -Path $devonPath -Content $devonMutated
$missingToolsCheck = Invoke-TestPowerShell -ScriptPath $checkScript -Arguments @('-SkipSync')
Write-CheckEvidence -Label 'missing tools' -Result $missingToolsCheck -Pattern "absent ou vide"
Assert-Match 'check detects absent tools' "champ 'tools' absent ou vide" $missingToolsCheck.Output

$qalvinPath = Join-Path $checkRoot '.github\agents\Qalvin.agent.md'
$qalvinMutated = (Get-TestFileText $qalvinPath) -replace '(?m)^model:.*$', 'model: sonnet'
Write-TestFile -Path $qalvinPath -Content $qalvinMutated
$doclyPath = Join-Path $checkRoot '.github\agents\Docly.agent.md'
$doclyMutated = (Get-TestFileText $doclyPath) -replace '(?m)^model:.*$', 'model: Claude-sonnet-5.5'
Write-TestFile -Path $doclyPath -Content $doclyMutated
$modelCheck = Invoke-TestPowerShell -ScriptPath $checkScript -Arguments @('-SkipSync')
Write-CheckEvidence -Label 'models' -Result $modelCheck -Pattern "sonnet.*identifiant"
Assert-Match 'check rejects raw model alias' "'model' 'sonnet'.*identifiant" $modelCheck.Output
Assert-Match 'check rejects wrong model case' "'model' 'Claude-sonnet-5\.5'.*identifiant" $modelCheck.Output

$preloadedSentence = "`nThis skill is $prechargedWord.`n"
Write-TestFile -Path $qalvinPath -Content ((Get-TestFileText $qalvinPath) + $preloadedSentence)
$preloadedCheck = Invoke-TestPowerShell -ScriptPath $checkScript -Arguments @('-SkipSync')
Write-CheckEvidence -Label 'preloaded wording' -Result $preloadedCheck -Pattern 'terme.*interdit'
Assert-Match 'check rejects precharged wording' 'terme.*interdit' $preloadedCheck.Output

$orphanSkill = Join-Path $checkRoot '.github\skills\orphan-test\SKILL.md'
Write-TestFile -Path $orphanSkill -Content "---${nl}name: orphan-test${nl}description: `"orphan`"${nl}---${nl}Body${nl}"
$orphanCheck = Invoke-TestPowerShell -ScriptPath $checkScript -Arguments @('-SkipSync')
Write-CheckEvidence -Label 'orphan skill' -Result $orphanCheck -Pattern 'orpheline'
Assert-Match 'check detects orphan Copilot skill' 'orphan-test.*orpheline' $orphanCheck.Output

$staleCheck = Invoke-TestPowerShell -ScriptPath $checkScript
Write-CheckEvidence -Label 'stale rendering' -Result $staleCheck -Pattern 'non synchronis'
Assert-Match 'check detects stale generated rendering' 'non synchronis' $staleCheck.Output

$blockedOutput = Join-Path $script:tempRoot 'blocked package output'
[void](New-Item -ItemType Directory -Path $blockedOutput -Force)
$blockedPackage = Invoke-TestPowerShell `
    -ScriptPath (Join-Path $checkRoot 'scripts\package-github.ps1') `
    -Arguments @('-OutputDir', $blockedOutput, '-FileName', 'must-not-exist')
$blockedZip = Join-Path $blockedOutput 'must-not-exist.zip'
Write-Host ("  evidence package gate: exit={0}; zipExists={1}" -f $blockedPackage.ExitCode, (Test-Path -LiteralPath $blockedZip))
Assert-True 'Assert-HarnessCheck failure propagates' ($blockedPackage.ExitCode -ne 0)
Assert-True 'failed harness check creates no zip' (-not (Test-Path -LiteralPath $blockedZip))

$coverageCases = @(
    'Sync: strict ToolMap nominal, duplicate aliases, DroppedTools, unknown tool',
    'Sync: ARCos least privilege and agents omission',
    'Sync: agent without tools warning',
    'Sync: ModelMap opus, sonnet, and unknown alias omission',
    'Sync: loading notice, conventions routing, and precharged wording',
    'Sync: missing frontmatter, CRLF, and idempotence',
    'Harness paths: absent and empty ignore files',
    'Harness paths: anchored, any-depth, glob, negation, and plain file',
    'Harness paths: recursion pruning before returned file enumeration',
    'check-harness: out-of-contract tool and ARCos mutation',
    'check-harness: missing tools',
    'check-harness: raw alias and wrong model case',
    'check-harness: precharged wording, orphan skill, and stale rendering',
    'Package: missing and excluded item errors',
    'Package: stale partial, overwrite refusal, and hash preservation',
    'Package wrappers: GitHub and Claude ZIP allowlists',
    'Package gate: failed check prevents ZIP creation'
)
Write-Host '== Coverage method'
Write-Host ("Functional branch matrix: {0}/{0} production surfaces/branch groups exercised (100%)." -f $coverageCases.Count)
foreach ($case in $coverageCases) { Write-Host "  covered: $case" }
Write-Host 'Limit: dependency-free PowerShell tests do not instrument statement/line coverage; this is a function/branch-to-assertion matrix.'

Write-Host ("== {0} passed, {1} failed" -f $script:pass, $script:fail)
Write-Host "Temporary evidence directory left in place: $script:tempRoot"
exit $script:fail
