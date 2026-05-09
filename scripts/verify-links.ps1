$ErrorActionPreference = "Stop"

$RepoRoot = Resolve-Path (Join-Path $PSScriptRoot "..")
$Manifest = Get-Content -Raw -Path (Join-Path $RepoRoot "skills.json") | ConvertFrom-Json
$TargetDir = if ($env:PI_SKILLS_DIR) { $env:PI_SKILLS_DIR } else { Join-Path $HOME ".pi/agent/skills" }
$Failures = @()

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

foreach ($Skill in $Manifest.external) {
    Test-SkillLink $Skill (Join-Path $RepoRoot "external/mattpocock-skills/$Skill")
}
foreach ($Skill in $Manifest.personal) {
    Test-SkillLink $Skill (Join-Path $RepoRoot "skills/$Skill")
}

if ($Failures.Count -gt 0) {
    $Failures | ForEach-Object { Write-Error $_ }
    exit 1
}

Write-Host "All skill links OK."
