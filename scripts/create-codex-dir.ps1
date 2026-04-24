[CmdletBinding()]
param()

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$repoRoot = Split-Path -Parent $scriptDir
$sourceDir = Join-Path $repoRoot '.claude'
$targetDir = Join-Path $repoRoot '.codex'

function Write-Log {
    param([string]$Message)
    Write-Host $Message
}

function Get-RelativePathCompat {
    param(
        [string]$BasePath,
        [string]$TargetPath
    )

    $pathType = [System.IO.Path]
    $bindingFlags = [System.Reflection.BindingFlags]::Public -bor [System.Reflection.BindingFlags]::Static
    $method = $pathType.GetMethod('GetRelativePath', $bindingFlags, $null, [Type[]]@([string], [string]), $null)
    if ($method) {
        return $method.Invoke($null, @($BasePath, $TargetPath))
    }

    $baseFullPath = [System.IO.Path]::GetFullPath($BasePath)
    $targetFullPath = [System.IO.Path]::GetFullPath($TargetPath)

    if (-not $baseFullPath.EndsWith([System.IO.Path]::DirectorySeparatorChar) -and
        -not $baseFullPath.EndsWith([System.IO.Path]::AltDirectorySeparatorChar)) {
        $baseFullPath = $baseFullPath + [System.IO.Path]::DirectorySeparatorChar
    }

    $baseUri = [System.Uri]::new($baseFullPath)
    $targetUri = [System.Uri]::new($targetFullPath)

    if ($baseUri.Scheme -ne $targetUri.Scheme) {
        return $targetFullPath
    }

    $relativeUri = $baseUri.MakeRelativeUri($targetUri)
    $relativePath = [System.Uri]::UnescapeDataString($relativeUri.ToString())
    return $relativePath.Replace('/', [System.IO.Path]::DirectorySeparatorChar)
}

function Convert-RelativePathForCodex {
    param([string]$Path)

    $mapped = $Path.Replace('.claude', '.codex')
    $mapped = $mapped.Replace('CLAUDE.md', 'AGENTS.md')
    $mapped = $mapped.Replace('claude', 'codex')
    $mapped = $mapped.Replace('Claude', 'Codex')
    return $mapped
}

function New-DirectoryIfMissing {
    param([string]$Dir)

    if (Test-Path -LiteralPath $Dir -PathType Container) {
        Write-Log "Exists $Dir"
        return
    }

    [void](New-Item -ItemType Directory -Path $Dir -Force)
    Write-Log "Creating $Dir"
}

function Get-RewrittenContent {
    param([string]$Path)

    $content = [System.IO.File]::ReadAllText($Path)
    $content = $content.Replace('.claude', '.codex')
    $content = $content.Replace('CLAUDE.md', 'AGENTS.md')
    $content = $content.Replace('claude', 'codex')
    $content = $content.Replace('Claude', 'Codex')
    return $content
}

function Set-ExecutableModeLikeSource {
    param(
        [string]$Source,
        [string]$Target
    )

    if (Test-IsWindowsPlatform) {
        return
    }

    try {
        $sourceItem = Get-Item -LiteralPath $Source
        $sourceMode = $sourceItem.UnixFileMode
        $hasAnyExecuteBit = (
            ($sourceMode -band [System.IO.UnixFileMode]::UserExecute) -ne 0 -or
            ($sourceMode -band [System.IO.UnixFileMode]::GroupExecute) -ne 0 -or
            ($sourceMode -band [System.IO.UnixFileMode]::OtherExecute) -ne 0
        )

        $targetMode = if ($hasAnyExecuteBit) {
            [System.IO.UnixFileMode]::UserRead -bor
            [System.IO.UnixFileMode]::UserWrite -bor
            [System.IO.UnixFileMode]::UserExecute -bor
            [System.IO.UnixFileMode]::GroupRead -bor
            [System.IO.UnixFileMode]::GroupExecute -bor
            [System.IO.UnixFileMode]::OtherRead -bor
            [System.IO.UnixFileMode]::OtherExecute
        } else {
            [System.IO.UnixFileMode]::UserRead -bor
            [System.IO.UnixFileMode]::UserWrite -bor
            [System.IO.UnixFileMode]::GroupRead -bor
            [System.IO.UnixFileMode]::OtherRead
        }

        [System.IO.File]::SetUnixFileMode($Target, $targetMode)
    } catch {
        # Ignore mode-setting failures so content mirroring still succeeds.
    }
}

function Test-IsWindowsPlatform {
    $platform = [Environment]::OSVersion.Platform
    return (
        $platform -eq [PlatformID]::Win32NT -or
        $platform -eq [PlatformID]::Win32S -or
        $platform -eq [PlatformID]::Win32Windows -or
        $platform -eq [PlatformID]::WinCE
    )
}

function Update-RewrittenFile {
    param(
        [string]$Source,
        [string]$Target,
        [string]$DisplayTarget
    )

    $tmpFile = [System.IO.Path]::GetTempFileName()

    try {
        $content = Get-RewrittenContent -Path $Source
        [System.IO.File]::WriteAllText($tmpFile, $content)

        if ((Test-Path -LiteralPath $Target -PathType Leaf) -and
            ([System.IO.File]::ReadAllText($tmpFile) -ceq [System.IO.File]::ReadAllText($Target))) {
            Write-Log "Unchanged $DisplayTarget"
            return
        }

        $relativeSource = (Get-RelativePathCompat -BasePath $repoRoot -TargetPath $Source).Replace('\', '/')

        if (Test-Path -LiteralPath $Target -PathType Leaf) {
            Write-Log "Updating $relativeSource -> $DisplayTarget"
        } else {
            Write-Log "Copying $relativeSource -> $DisplayTarget"
        }

        Move-Item -LiteralPath $tmpFile -Destination $Target -Force
        $tmpFile = $null
        Set-ExecutableModeLikeSource -Source $Source -Target $Target
    } finally {
        if ($tmpFile -and (Test-Path -LiteralPath $tmpFile)) {
            Remove-Item -LiteralPath $tmpFile -Force
        }
    }
}

if (-not (Test-Path -LiteralPath $sourceDir -PathType Container)) {
    Write-Error "Error: source directory not found: $sourceDir"
}

Write-Log 'Mirroring .claude -> .codex'
New-DirectoryIfMissing -Dir $targetDir

$relativeDirs = Get-ChildItem -LiteralPath $sourceDir -Directory -Recurse |
    ForEach-Object { (Get-RelativePathCompat -BasePath $sourceDir -TargetPath $_.FullName).Replace('\', '/') } |
    Sort-Object

foreach ($relativeDir in $relativeDirs) {
    $targetRelative = Convert-RelativePathForCodex -Path $relativeDir
    New-DirectoryIfMissing -Dir (Join-Path $targetDir $targetRelative)
}

$relativeFiles = Get-ChildItem -LiteralPath $sourceDir -File -Recurse |
    ForEach-Object { (Get-RelativePathCompat -BasePath $sourceDir -TargetPath $_.FullName).Replace('\', '/') } |
    Sort-Object

foreach ($relativeFile in $relativeFiles) {
    $sourcePath = Join-Path $sourceDir $relativeFile
    $targetRelative = Convert-RelativePathForCodex -Path $relativeFile
    $targetPath = Join-Path $targetDir $targetRelative
    $targetParent = Split-Path -Parent $targetPath

    New-DirectoryIfMissing -Dir $targetParent
    Update-RewrittenFile -Source $sourcePath -Target $targetPath -DisplayTarget ".codex/$targetRelative"
}
