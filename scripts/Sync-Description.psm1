<#
.SYNOPSIS
    Shared helpers for syncing content between .github/ (GitHub Copilot) and
    .opencode/ (OpenCode) agent/skill/instruction files.

    Syncs both the `description` frontmatter field AND the body (post-frontmatter)
    for structured files, plus full-file sync for standalone .md files.
    Platform-specific frontmatter fields (model/tools vs mode/permission) are preserved.

    Path substitution is applied to all copied content:
      github → opencode : .github/ replaced by .opencode/
      opencode → github : .opencode/ replaced by .github/
#>

$script:Utf8NoBom = New-Object System.Text.UTF8Encoding($false)

# ── Internal helpers ──────────────────────────────────────────────────────────

function Write-File {
    param([string]$Path, [string]$Content)
    [System.IO.File]::WriteAllText($Path, $Content, $script:Utf8NoBom)
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

function Apply-PathSubstitution {
    <#
    .SYNOPSIS
        Replaces .github/ with .opencode/ (or vice versa) in a string.
        Also substitutes platform-specific terms:
          github → opencode : .copilotignore → .gitignore  |  Copilot → OpenCode
          opencode → github : .gitignore → .copilotignore  |  OpenCode → Copilot
    .PARAMETER Direction
        'github-to-opencode' or 'opencode-to-github'
    #>
    param(
        [Parameter(Mandatory)][string]$Content,
        [Parameter(Mandatory)][ValidateSet('github-to-opencode','opencode-to-github')][string]$Direction
    )
    if ($Direction -eq 'github-to-opencode') {
        $r = $Content.Replace('.github/', '.opencode/')
        $r = $r.Replace('.copilotignore', '.gitignore')
        $r = $r.Replace('Copilot', 'OpenCode')
        return $r
    } else {
        $r = $Content.Replace('.opencode/', '.github/')
        $r = $r.Replace('.gitignore', '.copilotignore')
        $r = $r.Replace('OpenCode', 'Copilot')
        return $r
    }
}

# ── Description helpers ───────────────────────────────────────────────────────

function Get-YamlDescription {
    <#
    .SYNOPSIS
        Extracts the raw value of the `description` field from a YAML frontmatter block.
        Handles: quoted single-line, quoted multi-line, unquoted single-line, block scalar (>).
    .OUTPUTS
        The raw description value string (including surrounding quotes if present), or $null.
    #>
    param([Parameter(Mandatory)][string]$FilePath)

    $content = Get-Content $FilePath -Raw -Encoding UTF8
    $parts = Split-Frontmatter $content
    if ($null -eq $parts) { return $null }
    $frontmatter = $parts.Frontmatter

    # 1. Double-quoted string (single or multi-line)
    if ($frontmatter -match '(?s)description:\s*("(?:[^"\\]|\\.|\r?\n)*?(?<!\\)")') {
        return $Matches[1]
    }
    # 2. Single-quoted string
    if ($frontmatter -match "(?s)description:\s*('(?:[^'\\]|\\.|\r?\n)*?(?<!\\)')") {
        return $Matches[1]
    }
    # 3. Block scalar (> or |)
    if ($frontmatter -match '(?s)description:\s*[>|]\r?\n((?:[ \t]+[^\r\n]*\r?\n?)+)') {
        return '>' + [Environment]::NewLine + $Matches[1]
    }
    # 4. Unquoted single-line
    if ($frontmatter -match 'description:\s*([^\r\n]+)') {
        return $Matches[1].Trim()
    }
    return $null
}

function Set-YamlDescription {
    <#
    .SYNOPSIS
        Replaces the `description` field value in a file's YAML frontmatter.
    .OUTPUTS
        $true if file was (or would be) updated, $false if already identical.
    #>
    param(
        [Parameter(Mandatory)][string]$FilePath,
        [Parameter(Mandatory)][string]$NewDescription,
        [switch]$WhatIf
    )

    $content  = Get-Content $FilePath -Raw -Encoding UTF8
    $currentDesc = Get-YamlDescription -FilePath $FilePath

    if ($null -eq $currentDesc) {
        Write-Warning "  Cannot parse description in: $FilePath"
        return $false
    }
    if ($currentDesc -eq $NewDescription) { return $false }

    $newContent = $content.Replace("description: $currentDesc", "description: $NewDescription")

    if ($WhatIf) {
        $short = { param($s) $s.Substring(0, [Math]::Min(80, $s.Length)) }
        Write-Host "  [WhatIf] description: $(& $short $currentDesc)... → $(& $short $NewDescription)..."
    } else {
        Write-File $FilePath $newContent
    }
    return $true
}

# ── Body helpers ──────────────────────────────────────────────────────────────

function Get-FileBody {
    <#
    .SYNOPSIS
        Returns the body of a file (everything after the closing --- of the frontmatter).
        Returns the full content if the file has no frontmatter.
    #>
    param([Parameter(Mandatory)][string]$FilePath)

    $content = Get-Content $FilePath -Raw -Encoding UTF8
    $parts = Split-Frontmatter $content
    if ($null -eq $parts) { return $content }
    return $parts.Body
}

function Set-FileBody {
    <#
    .SYNOPSIS
        Replaces the body of a file while preserving its own frontmatter.
    .OUTPUTS
        $true if updated, $false if already identical.
    #>
    param(
        [Parameter(Mandatory)][string]$FilePath,
        [Parameter(Mandatory)][string]$NewBody,
        [switch]$WhatIf
    )

    $content = Get-Content $FilePath -Raw -Encoding UTF8
    $parts   = Split-Frontmatter $content

    if ($null -eq $parts) {
        # No frontmatter — replace entire file
        if ($content -eq $NewBody) { return $false }
        if (-not $WhatIf) { Write-File $FilePath $NewBody }
        return $true
    }

    if ($parts.Body -eq $NewBody) { return $false }

    $newContent = $parts.Frontmatter + $NewBody
    if (-not $WhatIf) { Write-File $FilePath $newContent }
    return $true
}

# ── Structured file sync (description + body) ────────────────────────────────

function Sync-StructuredFile {
    <#
    .SYNOPSIS
        Syncs both the `description` frontmatter field AND the body of a structured file
        (agent, skill, instruction). Platform-specific frontmatter fields are preserved.
        Path substitution is applied to the body content.
    .OUTPUTS
        'synced', 'ok', or 'warn'
    #>
    param(
        [Parameter(Mandatory)][string]$SourceFile,
        [Parameter(Mandatory)][string]$TargetFile,
        [Parameter(Mandatory)][ValidateSet('github-to-opencode','opencode-to-github')][string]$Direction,
        [switch]$WhatIf
    )

    if (-not (Test-Path $SourceFile)) {
        Write-Host "  [WARN] Source not found: $(Split-Path $SourceFile -Leaf)" -ForegroundColor Yellow
        return 'warn'
    }
    if (-not (Test-Path $TargetFile)) {
        Write-Host "  [WARN] Target not found: $(Split-Path $TargetFile -Leaf)" -ForegroundColor Yellow
        return 'warn'
    }

    $label = Split-Path $TargetFile -Leaf
    $changed = $false

    # 1. Sync description (with path substitution)
    $srcDesc = Get-YamlDescription -FilePath $SourceFile
    if ($null -eq $srcDesc) {
        Write-Host "  [WARN] Cannot parse description: $label" -ForegroundColor Yellow
        return 'warn'
    }
    $newDesc = Apply-PathSubstitution -Content $srcDesc -Direction $Direction
    $descChanged = Set-YamlDescription -FilePath $TargetFile -NewDescription $newDesc -WhatIf:$WhatIf
    if ($descChanged) { $changed = $true }

    # 2. Sync body (with path substitution)
    $srcBody = Get-FileBody -FilePath $SourceFile
    $newBody = Apply-PathSubstitution -Content $srcBody -Direction $Direction
    # Re-read target after potential description update (need fresh content for body comparison)
    $bodyChanged = Set-FileBody -FilePath $TargetFile -NewBody $newBody -WhatIf:$WhatIf
    if ($bodyChanged) { $changed = $true }

    if ($changed) {
        $tag = if ($WhatIf) { '[WHATIF]' } else { '[SYNC]' }
        Write-Host "  $tag  $label" -ForegroundColor Cyan
        return 'synced'
    } else {
        Write-Host "  [OK]   $label" -ForegroundColor Green
        return 'ok'
    }
}

# ── Standalone file sync ──────────────────────────────────────────────────────

function Sync-StandaloneFile {
    <#
    .SYNOPSIS
        Syncs a standalone .md file from source to target (full content, with path substitution).
        Creates the target file if it does not exist.
    .OUTPUTS
        'synced', 'ok', or 'warn'
    #>
    param(
        [Parameter(Mandatory)][string]$SourceFile,
        [Parameter(Mandatory)][string]$TargetFile,
        [Parameter(Mandatory)][ValidateSet('github-to-opencode','opencode-to-github')][string]$Direction,
        [switch]$WhatIf
    )

    if (-not (Test-Path $SourceFile)) {
        Write-Host "  [WARN] Source not found: $(Split-Path $SourceFile -Leaf)" -ForegroundColor Yellow
        return 'warn'
    }

    $label   = Split-Path $TargetFile -Leaf
    $srcContent = Get-Content $SourceFile -Raw -Encoding UTF8
    $newContent = Apply-PathSubstitution -Content $srcContent -Direction $Direction

    $isNew = -not (Test-Path $TargetFile)

    if (-not $isNew) {
        $tgtContent = Get-Content $TargetFile -Raw -Encoding UTF8
        if ($tgtContent -eq $newContent) {
            Write-Host "  [OK]   $label" -ForegroundColor Green
            return 'ok'
        }
    }

    $action = if ($isNew) { 'CREATE' } else { 'SYNC' }
    if ($WhatIf) {
        Write-Host "  [WHATIF] Would $action $label" -ForegroundColor Cyan
    } else {
        $dir = Split-Path $TargetFile -Parent
        if (-not (Test-Path $dir)) { New-Item -ItemType Directory -Path $dir -Force | Out-Null }
        Write-File $TargetFile $newContent
        Write-Host "  [$action]  $label" -ForegroundColor Cyan
    }
    return 'synced'
}

# ── Batch helpers ─────────────────────────────────────────────────────────────

function Sync-AgentFiles {
    <#
    .SYNOPSIS
        Syncs description + body for a set of structured source files to their counterparts.
    .PARAMETER SourceFiles
        Array of source file paths.
    .PARAMETER SourceBase
        Base directory of source files (to compute relative path).
    .PARAMETER TargetBase
        Base directory of target files.
    .PARAMETER Direction
        'github-to-opencode' or 'opencode-to-github'
    .PARAMETER WhatIf
        Dry-run.
    #>
    param(
        [Parameter(Mandatory)][string[]]$SourceFiles,
        [Parameter(Mandatory)][string]$SourceBase,
        [Parameter(Mandatory)][string]$TargetBase,
        [Parameter(Mandatory)][ValidateSet('github-to-opencode','opencode-to-github')][string]$Direction,
        [switch]$WhatIf
    )

    $counts = @{ synced = 0; ok = 0; warn = 0 }

    foreach ($src in $SourceFiles) {
        $rel    = $src.Substring($SourceBase.Length).TrimStart('\', '/')
        $target = Join-Path $TargetBase $rel

        $result = Sync-StructuredFile -SourceFile $src -TargetFile $target -Direction $Direction -WhatIf:$WhatIf
        $counts[$result]++
    }

    return $counts
}

function Sync-StandaloneFiles {
    <#
    .SYNOPSIS
        Syncs a list of standalone .md files from SourceBase to TargetBase.
    .PARAMETER FileNames
        List of file names (relative to SourceBase) to sync.
    #>
    param(
        [Parameter(Mandatory)][string[]]$FileNames,
        [Parameter(Mandatory)][string]$SourceBase,
        [Parameter(Mandatory)][string]$TargetBase,
        [Parameter(Mandatory)][ValidateSet('github-to-opencode','opencode-to-github')][string]$Direction,
        [switch]$WhatIf
    )

    $counts = @{ synced = 0; ok = 0; warn = 0 }

    foreach ($name in $FileNames) {
        $src    = Join-Path $SourceBase $name
        $target = Join-Path $TargetBase $name

        $result = Sync-StandaloneFile -SourceFile $src -TargetFile $target -Direction $Direction -WhatIf:$WhatIf
        $counts[$result]++
    }

    return $counts
}

Export-ModuleMember -Function `
    Get-YamlDescription, Set-YamlDescription, `
    Get-FileBody, Set-FileBody, `
    Apply-PathSubstitution, `
    Sync-StructuredFile, Sync-StandaloneFile, `
    Sync-AgentFiles, Sync-StandaloneFiles
