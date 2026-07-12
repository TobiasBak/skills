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
$Failures = @()

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
        $Duplicates | ForEach-Object {
            $Paths = $_.Group | ForEach-Object { $_.Source }
            $script:Failures += "Duplicate skill name '$($_.Name)': $($Paths -join ', ')"
        }
    }

    return @($Sources | Sort-Object Name)
}

function Test-SkillLink($Name, $Source) {
    $Expected = (Resolve-Path $Source).Path
    $Target = Join-Path $TargetDir $Name
    if (!(Test-Path -LiteralPath $Target)) {
        $script:Failures += "Missing: $Target -> $Expected"
        return
    }
    $Item = Get-Item -LiteralPath $Target -Force
    if (!$Item.LinkType) {
        $script:Failures += "Not link: $Target (expected -> $Expected)"
        return
    }
    $Actual = ($Item.Target -join ";")
    if ([System.IO.Path]::GetFullPath($Actual) -ne [System.IO.Path]::GetFullPath($Expected)) {
        $script:Failures += "Wrong target: $Target -> $Actual (expected -> $Expected)"
        return
    }
    Write-Host "OK: $Target -> $Expected"
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

function Test-NoStaleSkillLinks($Skills) {
    $Expected = @{}
    foreach ($Skill in $Skills) {
        $Expected[$Skill.Name] = $true
    }

    if (!(Test-Path -LiteralPath $TargetDir)) {
        return
    }

    Get-ChildItem -Force -LiteralPath $TargetDir | ForEach-Object {
        if (!$Expected.ContainsKey($_.Name) -and (Test-ManagedSkillLink $_)) {
            $script:Failures += "Stale managed link: $($_.FullName) (no longer discovered from $RepoRoot)"
        }
    }
}

$SkillSources = @(Get-SkillSources)
foreach ($Skill in $SkillSources) {
    Test-SkillLink $Skill.Name $Skill.Source
}

Test-NoStaleSkillLinks $SkillSources

if ($Failures.Count -gt 0) {
    $Failures | ForEach-Object { Write-Error $_ }
    exit 1
}

Write-Host "All skill links OK."
