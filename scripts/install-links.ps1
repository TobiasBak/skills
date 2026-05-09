param(
    [switch]$Fix
)

$ErrorActionPreference = "Stop"

$RepoRoot = Resolve-Path (Join-Path $PSScriptRoot "..")
$ManifestPath = Join-Path $RepoRoot "skills.json"
$Manifest = Get-Content -Raw -Path $ManifestPath | ConvertFrom-Json
$TargetDir = if ($env:PI_SKILLS_DIR) { $env:PI_SKILLS_DIR } else { Join-Path $HOME ".pi/agent/skills" }
New-Item -ItemType Directory -Force -Path $TargetDir | Out-Null

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
        Remove-Item -LiteralPath $Target -Recurse -Force
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

foreach ($Skill in $Manifest.external) {
    Assert-Or-LinkSkill $Skill (Join-Path $RepoRoot "external/mattpocock-skills/$Skill")
}

foreach ($Skill in $Manifest.personal) {
    Assert-Or-LinkSkill $Skill (Join-Path $RepoRoot "skills/$Skill")
}
