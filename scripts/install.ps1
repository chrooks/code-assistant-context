[CmdletBinding()]
param(
    [switch]$Claude,
    [switch]$Codex,
    [switch]$DryRun
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$repoRoot = Split-Path -Parent $scriptDir
$homeDir = [Environment]::GetFolderPath('UserProfile')

function Show-Usage {
    $scriptName = Split-Path -Leaf $MyInvocation.MyCommand.Path
    @"
Usage: $scriptName [-Claude] [-Codex] [-DryRun]

Copy agent config directories from this repo to your home directory.

Flags:
  -Claude   Copy .claude/ to ~/.claude/
  -Codex    Copy .codex/ to ~/.codex/
  -DryRun   Show what would be copied without doing it

At least one of -Claude or -Codex is required.
Both can be specified together.
"@ | Write-Host
}

function Copy-MergeDirectory {
    param(
        [string]$Source,
        [string]$Destination
    )

    if (-not (Test-Path -LiteralPath $Destination -PathType Container)) {
        [void](New-Item -ItemType Directory -Path $Destination -Force)
    }

    $entries = Get-ChildItem -LiteralPath $Source -Force -Recurse | Sort-Object FullName
    foreach ($entry in $entries) {
        $relativePath = [System.IO.Path]::GetRelativePath($Source, $entry.FullName)
        $targetPath = Join-Path $Destination $relativePath

        if ($entry.PSIsContainer) {
            if (-not (Test-Path -LiteralPath $targetPath -PathType Container)) {
                [void](New-Item -ItemType Directory -Path $targetPath -Force)
                Write-Host "cd+++++++++ $relativePath/"
            }

            continue
        }

        $parent = Split-Path -Parent $targetPath
        if (-not (Test-Path -LiteralPath $parent -PathType Container)) {
            [void](New-Item -ItemType Directory -Path $parent -Force)
        }

        $targetExists = Test-Path -LiteralPath $targetPath -PathType Leaf
        $copyNeeded = $true
        if ($targetExists) {
            $sourceItem = Get-Item -LiteralPath $entry.FullName
            $targetItem = Get-Item -LiteralPath $targetPath
            $copyNeeded = -not (
                $sourceItem.Length -eq $targetItem.Length -and
                [Convert]::ToHexString([System.Security.Cryptography.SHA256]::HashData([System.IO.File]::ReadAllBytes($entry.FullName))) -eq
                [Convert]::ToHexString([System.Security.Cryptography.SHA256]::HashData([System.IO.File]::ReadAllBytes($targetPath)))
            )
        }

        if ($copyNeeded) {
            Copy-Item -LiteralPath $entry.FullName -Destination $targetPath -Force
            $status = if ($targetExists) { '>f.st......' } else { '>f+++++++++' }
            Write-Host "$status $relativePath"
        }
    }
}

function Install-Dir {
    param(
        [string]$Source,
        [string]$Destination,
        [string]$Label
    )

    if (-not (Test-Path -LiteralPath $Source -PathType Container)) {
        Write-Error "Error: source directory not found: $Source`n  Run scripts/create-codex-dir.sh first if installing -Codex"
    }

    Write-Host "Installing $Label`: $Source -> $Destination"

    if ($DryRun) {
        Write-Host "  [dry-run] would copy $Source/ to $Destination/"
        return
    }

    Copy-MergeDirectory -Source $Source -Destination $Destination
    Write-Host "Done: $Label installed to $Destination"
}

if (-not $Claude -and -not $Codex) {
    Write-Host 'Error: specify at least one of -Claude or -Codex' -ForegroundColor Red
    Show-Usage
    exit 1
}

if ($Claude) {
    Install-Dir -Source (Join-Path $repoRoot '.claude') -Destination (Join-Path $homeDir '.claude') -Label '.claude'
}

if ($Codex) {
    Install-Dir -Source (Join-Path $repoRoot '.codex') -Destination (Join-Path $homeDir '.codex') -Label '.codex'
}

Write-Host ''
Write-Host 'Install complete.'
