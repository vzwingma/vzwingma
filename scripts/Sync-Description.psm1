<#
.SYNOPSIS
    Shared helpers for syncing the `description` frontmatter field between
    .github/ (GitHub Copilot) and .opencode/ (OpenCode) agent/skill/instruction files.
#>

function Get-YamlDescription {
    <#
    .SYNOPSIS
        Extracts the raw value of the `description` field from a YAML frontmatter block.
        Handles: quoted single-line, quoted multi-line, unquoted single-line, block scalar (>).
    .OUTPUTS
        The raw description value string (including surrounding quotes if present), or $null.
    #>
    param(
        [Parameter(Mandatory)][string]$FilePath
    )

    $content = Get-Content $FilePath -Raw -Encoding UTF8

    # Extract frontmatter block (between first two --- markers)
    if ($content -notmatch '(?s)^---\r?\n(.*?)\r?\n---') { return $null }
    $frontmatter = $Matches[1]

    # 1. Quoted string (single or multi-line): description: "..." or description: '...'
    #    Multi-line quoted strings contain real newlines inside the quotes.
    if ($frontmatter -match '(?s)description:\s*("(?:[^"\\]|\\.|\r?\n)*?(?<!\\)")') {
        return $Matches[1]
    }
    if ($frontmatter -match "(?s)description:\s*('(?:[^'\\]|\\.|\r?\n)*?(?<!\\)')") {
        return $Matches[1]
    }

    # 2. Block scalar (> or |): value on following indented lines
    if ($frontmatter -match '(?s)description:\s*[>|]\r?\n((?:[ \t]+[^\r\n]*\r?\n?)+)') {
        return '>' + [Environment]::NewLine + $Matches[1]
    }

    # 3. Unquoted single-line
    if ($frontmatter -match 'description:\s*([^\r\n]+)') {
        return $Matches[1].Trim()
    }

    return $null
}


function Set-YamlDescription {
    <#
    .SYNOPSIS
        Replaces the `description` field value in a file's YAML frontmatter.
    .PARAMETER FilePath
        Target file to update.
    .PARAMETER NewDescription
        The raw description value to write (as returned by Get-YamlDescription).
    .PARAMETER WhatIf
        If set, prints what would change without writing.
    .OUTPUTS
        $true if file was (or would be) updated, $false if already identical.
    #>
    param(
        [Parameter(Mandatory)][string]$FilePath,
        [Parameter(Mandatory)][string]$NewDescription,
        [switch]$WhatIf
    )

    $content = Get-Content $FilePath -Raw -Encoding UTF8
    $currentDesc = Get-YamlDescription -FilePath $FilePath

    if ($null -eq $currentDesc) {
        Write-Warning "  Cannot parse description in: $FilePath"
        return $false
    }

    if ($currentDesc -eq $NewDescription) {
        return $false  # already in sync
    }

    # Build old and new description line(s) for replacement
    $oldBlock = "description: $currentDesc"
    $newBlock = "description: $NewDescription"

    $newContent = $content.Replace($oldBlock, $newBlock)

    if ($WhatIf) {
        Write-Host "  [WhatIf] Would replace description in: $(Split-Path $FilePath -Leaf)"
        Write-Host "    OLD: $($currentDesc.Substring(0, [Math]::Min(80, $currentDesc.Length)))..."
        Write-Host "    NEW: $($NewDescription.Substring(0, [Math]::Min(80, $NewDescription.Length)))..."
    } else {
        # Preserve original line endings
        $encoding = New-Object System.Text.UTF8Encoding($false)  # UTF-8 without BOM
        [System.IO.File]::WriteAllText($FilePath, $newContent, $encoding)
    }

    return $true
}


function Sync-FileDescription {
    <#
    .SYNOPSIS
        Syncs the `description` field from a source file to a target file.
    .OUTPUTS
        'synced', 'ok', or 'warn'
    #>
    param(
        [Parameter(Mandatory)][string]$SourceFile,
        [Parameter(Mandatory)][string]$TargetFile,
        [switch]$WhatIf
    )

    if (-not (Test-Path $SourceFile)) {
        Write-Host "  [WARN] Source not found: $SourceFile" -ForegroundColor Yellow
        return 'warn'
    }
    if (-not (Test-Path $TargetFile)) {
        Write-Host "  [WARN] Target not found: $TargetFile" -ForegroundColor Yellow
        return 'warn'
    }

    $srcDesc = Get-YamlDescription -FilePath $SourceFile
    if ($null -eq $srcDesc) {
        Write-Host "  [WARN] Could not parse description in: $SourceFile" -ForegroundColor Yellow
        return 'warn'
    }

    $updated = Set-YamlDescription -FilePath $TargetFile -NewDescription $srcDesc -WhatIf:$WhatIf
    $label = Split-Path $TargetFile -Leaf

    if ($updated) {
        $tag = if ($WhatIf) { '[WHATIF]' } else { '[SYNC]' }
        Write-Host "  $tag $label" -ForegroundColor Cyan
        return 'synced'
    } else {
        Write-Host "  [OK]   $label" -ForegroundColor Green
        return 'ok'
    }
}


function Sync-AgentFiles {
    <#
    .SYNOPSIS
        Syncs description for a set of source files to their counterparts in a target directory.
        Handles both flat (agents, instructions) and nested (skills) structures.
    .PARAMETER SourceFiles
        Array of source file paths.
    .PARAMETER SourceBase
        Base directory of source files (used to compute relative path).
    .PARAMETER TargetBase
        Base directory of target files.
    .PARAMETER WhatIf
        Dry-run.
    #>
    param(
        [Parameter(Mandatory)][string[]]$SourceFiles,
        [Parameter(Mandatory)][string]$SourceBase,
        [Parameter(Mandatory)][string]$TargetBase,
        [switch]$WhatIf
    )

    $counts = @{ synced = 0; ok = 0; warn = 0 }

    foreach ($src in $SourceFiles) {
        # Compute relative path from source base
        $rel = $src.Substring($SourceBase.Length).TrimStart('\', '/')
        $target = Join-Path $TargetBase $rel

        $result = Sync-FileDescription -SourceFile $src -TargetFile $target -WhatIf:$WhatIf
        $counts[$result]++
    }

    return $counts
}

Export-ModuleMember -Function Get-YamlDescription, Set-YamlDescription, Sync-FileDescription, Sync-AgentFiles
