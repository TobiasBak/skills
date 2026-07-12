param(
    [switch]$Fix
)

$ErrorActionPreference = "Stop"

$RepoRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
$TargetDir = if ($env:PI_SKILLS_DIR) { $env:PI_SKILLS_DIR } else { Join-Path $HOME ".pi/agent/skills" }
$ExcludedSkills = @{}
if ($env:SKILLS_EXCLUDE) {
    $env:SKILLS_EXCLUDE -split "," | ForEach-Object {
        $Name = $_.Trim()
        if ($Name) { $ExcludedSkills[$Name] = $true }
    }
}
New-Item -ItemType Directory -Force -Path $TargetDir | Out-Null

function Get-SkillSources {
    $Sources = @()

    $PersonalRoot = Join-Path $RepoRoot "skills"
    if (Test-Path -LiteralPath $PersonalRoot) {
        Get-ChildItem -Directory -LiteralPath $PersonalRoot | ForEach-Object {
            if (Test-Path -LiteralPath (Join-Path $_.FullName "SKILL.md")) {
                $Sources += [pscustomobject]@{
                    Name = $_.Name
                    Source = (Resolve-Path $_.FullName).Path
                }
            }
        }
    }

    $ExternalRoot = Join-Path $RepoRoot "external"
    if (Test-Path -LiteralPath $ExternalRoot) {
        Get-ChildItem -Directory -LiteralPath $ExternalRoot | ForEach-Object {
            Get-ChildItem -Directory -LiteralPath $_.FullName | ForEach-Object {
                if (Test-Path -LiteralPath (Join-Path $_.FullName "SKILL.md")) {
                    $Sources += [pscustomobject]@{
                        Name = $_.Name
                        Source = (Resolve-Path $_.FullName).Path
                    }
                }
            }
        }
    }

    $Sources = @($Sources | Where-Object { !$ExcludedSkills.ContainsKey($_.Name) })

    $Duplicates = @($Sources | Group-Object Name | Where-Object { $_.Count -gt 1 })
    if ($Duplicates.Count -gt 0) {
        $Message = $Duplicates | ForEach-Object {
            $Paths = $_.Group | ForEach-Object { $_.Source }
            "Duplicate skill name '$($_.Name)': $($Paths -join ', ')"
        }
        throw ($Message -join "`n")
    }

    return @($Sources | Sort-Object Name)
}

function Get-LinkTarget($Path) {
    if (!(Test-Path -LiteralPath $Path)) { return $null }
    $Item = Get-Item -LiteralPath $Path -Force
    if ($Item.LinkType) { return ($Item.Target -join ";") }
    return $null
}

function Assert-Or-LinkSkill($Name, $Source) {
    $SourcePath = (Resolve-Path $Source).Path
    $SkillFile = Join-Path $SourcePath "SKILL.md"
    if (!(Test-Path -LiteralPath $SkillFile)) {
        throw "Missing SKILL.md: $SourcePath"
    }

    $Target = Join-Path $TargetDir $Name
    $ExistingTarget = Get-LinkTarget $Target
    if ($ExistingTarget) {
        if ([System.IO.Path]::GetFullPath($ExistingTarget) -eq [System.IO.Path]::GetFullPath($SourcePath)) {
            Write-Host "OK: $Target -> $SourcePath"
            return
        }
        if (!$Fix) { throw "Wrong link target: $Target -> $ExistingTarget; expected $SourcePath. Re-run with -Fix." }
        Remove-Item -LiteralPath $Target -Force
    } elseif (Test-Path -LiteralPath $Target) {
        if (!$Fix) { throw "Exists but not link: $Target. Re-run with -Fix to replace." }
        Remove-Item -LiteralPath $Target -Recurse -Force
    }

    try {
        New-Item -ItemType SymbolicLink -Path $Target -Target $SourcePath | Out-Null
    } catch {
        New-Item -ItemType Junction -Path $Target -Target $SourcePath | Out-Null
    }
    Write-Host "Linked: $Target -> $SourcePath"
}

function Test-ManagedSkillLink($Item) {
    if (!$Item.LinkType) { return $false }
    $RawTarget = ($Item.Target -join ";")
    $Target = if ([System.IO.Path]::IsPathRooted($RawTarget)) {
        [System.IO.Path]::GetFullPath($RawTarget)
    } else {
        [System.IO.Path]::GetFullPath((Join-Path $Item.DirectoryName $RawTarget))
    }
    $ManagedRoots = @(
        [System.IO.Path]::GetFullPath((Join-Path $RepoRoot "skills")),
        [System.IO.Path]::GetFullPath((Join-Path $RepoRoot "external"))
    )
    foreach ($Root in $ManagedRoots) {
        if ($Target.StartsWith($Root + [System.IO.Path]::DirectorySeparatorChar, [System.StringComparison]::OrdinalIgnoreCase)) {
            return $true
        }
    }
    return $false
}

function Remove-StaleSkillLinks($Skills) {
    $Expected = @{}
    foreach ($Skill in $Skills) {
        $Expected[$Skill.Name] = $true
    }

    Get-ChildItem -Force -LiteralPath $TargetDir | ForEach-Object {
        if ($Expected.ContainsKey($_.Name)) { return }

        if (Test-ManagedSkillLink $_) {
            if (!$Fix) { throw "Stale managed skill link: $($_.FullName). Re-run with -Fix to remove it." }
            Remove-Item -LiteralPath $_.FullName -Force
            Write-Host "Removed stale: $($_.FullName)"
            return
        }

        Write-Host "Leaving unmanaged entry: $($_.FullName)"
    }
}

$SkillSources = @(Get-SkillSources)
foreach ($Skill in $SkillSources) {
    Assert-Or-LinkSkill $Skill.Name $Skill.Source
}

Remove-StaleSkillLinks $SkillSources
