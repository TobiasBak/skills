$ErrorActionPreference = "Stop"

$RepoRoot = Resolve-Path (Join-Path $PSScriptRoot "..")
$TargetDir = if ($env:PI_SKILLS_DIR) { $env:PI_SKILLS_DIR } else { Join-Path $HOME ".pi/agent/skills" }
New-Item -ItemType Directory -Force -Path $TargetDir | Out-Null

function Link-Skill($Name, $Source) {
    $SourcePath = Resolve-Path $Source
    $SkillFile = Join-Path $SourcePath "SKILL.md"
    if (!(Test-Path $SkillFile)) {
        throw "Missing SKILL.md: $SourcePath"
    }

    $Target = Join-Path $TargetDir $Name
    if (Test-Path $Target) {
        Write-Host "Exists, skipping: $Target"
        return
    }

    try {
        New-Item -ItemType SymbolicLink -Path $Target -Target $SourcePath | Out-Null
    } catch {
        New-Item -ItemType Junction -Path $Target -Target $SourcePath | Out-Null
    }
    Write-Host "Linked: $Target -> $SourcePath"
}

@("caveman", "grill-me", "write-a-skill", "improve-codebase-architecture", "tdd") | ForEach-Object {
    Link-Skill $_ (Join-Path $RepoRoot "external/mattpocock-skills/$_")
}

Get-ChildItem (Join-Path $RepoRoot "skills") -Directory | ForEach-Object {
    if (Test-Path (Join-Path $_.FullName "SKILL.md")) {
        Link-Skill $_.Name $_.FullName
    }
}
