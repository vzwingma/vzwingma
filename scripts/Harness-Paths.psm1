<#
.SYNOPSIS
    Shared path-exclusion helpers (AP 006 T2.3). Exclusions are applied BEFORE descending into a directory,
    so excluded or foreign trees (other checkouts, build output, .copilotignore folders) are never walked.

    Compatible with Windows PowerShell 5.1 and PowerShell 7.
#>

$script:DefaultExcludedDirs = @('**/.git', '**/node_modules', 'dist', '.claude/worktrees')

function Get-HarnessExcludedDirs {
    <#
    .SYNOPSIS  Excluded directories: repo-relative paths with '/' separators (anchored at the root), or
               '**/name' (matches a directory of that name at any depth).
    .DESCRIPTION
        Built-in defaults + directory entries of <RepoRoot>/.copilotignore, with gitignore semantics:
        '/name/' or 'a/b/' are anchored at the root; 'name/' (no other slash) matches at any depth.
        Other .copilotignore pattern forms (globs, files) are not interpreted here; they are reported by
        Get-HarnessUnsupportedIgnoreEntries so they are never silently assumed to be honoured.
    #>
    param([Parameter(Mandatory)][string]$RepoRoot)

    $dirs = New-Object System.Collections.Generic.List[string]
    foreach ($d in $script:DefaultExcludedDirs) { $dirs.Add($d) }
    $ignore = Join-Path $RepoRoot '.copilotignore'
    if (Test-Path -LiteralPath $ignore -PathType Leaf) {
        foreach ($line in [System.IO.File]::ReadAllLines($ignore)) {
            $entry = $line.Trim()
            if ($entry -eq '' -or $entry.StartsWith('#') -or $entry.StartsWith('!')) { continue }
            if ($entry -match '[\*\?\[]') { continue }
            if ($entry.EndsWith('/')) {
                $norm = $entry.Trim('/')
                if ($norm -eq '') { continue }
                if (-not $entry.StartsWith('/') -and $norm -notmatch '/') { $norm = '**/' + $norm }
                if (-not $dirs.Contains($norm)) { $dirs.Add($norm) }
            }
        }
    }
    return $dirs.ToArray()
}

function Get-HarnessUnsupportedIgnoreEntries {
    <#
    .SYNOPSIS  .copilotignore entries this module does not interpret (globs, negations, plain files).
    #>
    param([Parameter(Mandatory)][string]$RepoRoot)

    $ignore = Join-Path $RepoRoot '.copilotignore'
    if (-not (Test-Path -LiteralPath $ignore -PathType Leaf)) { return @() }
    $out = New-Object System.Collections.Generic.List[string]
    foreach ($line in [System.IO.File]::ReadAllLines($ignore)) {
        $entry = $line.Trim()
        if ($entry -eq '' -or $entry.StartsWith('#')) { continue }
        if ($entry.StartsWith('!') -or $entry -match '[\*\?\[]' -or -not $entry.EndsWith('/')) { $out.Add($entry) }
    }
    return $out.ToArray()
}

function Test-HarnessExcludedPath {
    <#
    .SYNOPSIS  True when the path equals or lies under an excluded directory.
    #>
    param(
        [Parameter(Mandatory)][string]$RepoRoot,
        [Parameter(Mandatory)][string]$Path,
        [string[]]$ExcludedDirs
    )
    if (-not $ExcludedDirs) { $ExcludedDirs = Get-HarnessExcludedDirs -RepoRoot $RepoRoot }
    $root = $RepoRoot.TrimEnd('\', '/')
    $full = [System.IO.Path]::GetFullPath($Path)
    if ($full.Length -le $root.Length) { return $false }
    $rel = $full.Substring($root.Length).TrimStart('\', '/').Replace('\', '/')
    $segments = $rel -split '/'
    foreach ($ex in $ExcludedDirs) {
        if ($ex.StartsWith('**/')) {
            $name = $ex.Substring(3)
            foreach ($seg in $segments) { if ($seg -eq $name) { return $true } }
        } elseif ($rel -eq $ex -or $rel.StartsWith($ex + '/', [System.StringComparison]::OrdinalIgnoreCase)) {
            return $true
        }
    }
    return $false
}

function Get-HarnessFiles {
    <#
    .SYNOPSIS  Recursive file listing that prunes excluded directories before descending.
    .PARAMETER Path        Directory to walk.
    .PARAMETER Filter      Optional file name wildcard (e.g. '*.md').
    .PARAMETER Recurse     Walk sub-directories (default: top level only).
    #>
    param(
        [Parameter(Mandatory)][string]$RepoRoot,
        [Parameter(Mandatory)][string]$Path,
        [string]$Filter = '*',
        [switch]$Recurse
    )

    $excluded = @(Get-HarnessExcludedDirs -RepoRoot $RepoRoot)
    $pending = New-Object System.Collections.Generic.Stack[string]
    $pending.Push($Path)
    $result = New-Object System.Collections.Generic.List[object]
    while ($pending.Count -gt 0) {
        $dir = $pending.Pop()
        if (Test-HarnessExcludedPath -RepoRoot $RepoRoot -Path $dir -ExcludedDirs $excluded) { continue }
        foreach ($entry in Get-ChildItem -LiteralPath $dir -Force) {
            if ($entry.PSIsContainer) {
                if ($Recurse) { $pending.Push($entry.FullName) }
            } elseif ($entry.Name -like $Filter) {
                $result.Add($entry)
            }
        }
    }
    return $result.ToArray()
}

Export-ModuleMember -Function Get-HarnessExcludedDirs, Get-HarnessUnsupportedIgnoreEntries, Test-HarnessExcludedPath, Get-HarnessFiles
