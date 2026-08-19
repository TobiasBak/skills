param(
    [switch]$Force
)

$ErrorActionPreference = "Stop"

$SkillSources = @(
    [pscustomobject]@{ Name = "domain-modeling"; UpstreamPath = "skills/engineering/domain-modeling"; RepoPath = "external/mattpocock-skills/domain-modeling" }
    [pscustomobject]@{ Name = "grill-with-docs"; UpstreamPath = "skills/engineering/grill-with-docs"; RepoPath = "external/mattpocock-skills/grill-with-docs" }
    [pscustomobject]@{ Name = "grilling"; UpstreamPath = "skills/productivity/grilling"; RepoPath = "external/mattpocock-skills/grilling" }
)

function Invoke-Git {
    & git @args
    if ($LASTEXITCODE -ne 0) {
        throw "git $($args -join ' ') failed with exit code $LASTEXITCODE."
    }
}

$Dest = (Resolve-Path $PSScriptRoot).Path
$RepoRoot = (Resolve-Path (Join-Path $Dest "../..")).Path
$Tmp = Join-Path ([System.IO.Path]::GetTempPath()) ("skills-" + [System.Guid]::NewGuid())

try {
    New-Item -ItemType Directory -Path $Tmp | Out-Null
    $UpstreamRepo = Join-Path $Tmp "repo"
    Invoke-Git clone --depth 1 --filter=blob:none --sparse https://github.com/mattpocock/skills $UpstreamRepo
    $UpstreamCommit = Invoke-Git -C $UpstreamRepo rev-parse HEAD
    Invoke-Git -C $UpstreamRepo sparse-checkout set --no-cone `
        /skills/engineering/domain-modeling `
        /skills/engineering/grill-with-docs `
        /skills/productivity/grilling

    foreach ($SkillSource in $SkillSources) {
        $SkillFile = Join-Path $UpstreamRepo "$($SkillSource.UpstreamPath)/SKILL.md"
        if (!(Test-Path -LiteralPath $SkillFile)) {
            throw "Selected Matt Pocock skill is missing upstream: $($SkillSource.UpstreamPath)"
        }
    }

    $CurrentSkillPaths = @(
        Get-ChildItem -Directory -LiteralPath $Dest | Where-Object {
            Test-Path -LiteralPath (Join-Path $_.FullName "SKILL.md")
        } | ForEach-Object {
            "external/mattpocock-skills/$($_.Name)"
        }
    )
    $TargetSkillPaths = @($SkillSources | ForEach-Object { $_.RepoPath })
    $ManagedSkillPaths = @($CurrentSkillPaths + $TargetSkillPaths | Sort-Object -Unique)

    if ($ManagedSkillPaths.Count -gt 0) {
        $PendingChanges = @(Invoke-Git -C $RepoRoot status --short -- $ManagedSkillPaths)
        if ($PendingChanges.Count -gt 0 -and !$Force) {
            throw ("Refusing to overwrite vendored skills with uncommitted local changes:`n" +
                ($PendingChanges -join "`n") +
                "`nReview or commit these changes, then rerun. Use -Force only when you intentionally want to overwrite them.")
        }
    }

    $PreparedRoot = Join-Path $Tmp "prepared"
    $PreparedDest = Join-Path $PreparedRoot "external/mattpocock-skills"
    New-Item -ItemType Directory -Force -Path $PreparedDest | Out-Null

    foreach ($SkillSource in $SkillSources) {
        $SkillDest = Join-Path $PreparedDest $SkillSource.Name
        Copy-Item -Recurse -LiteralPath (Join-Path $UpstreamRepo $SkillSource.UpstreamPath) -Destination $SkillDest

        $Metadata = Join-Path $Dest "$($SkillSource.Name)/agents/openai.yaml"
        if (Test-Path -LiteralPath $Metadata) {
            $MetadataDest = Join-Path $SkillDest "agents/openai.yaml"
            New-Item -ItemType Directory -Force -Path (Split-Path $MetadataDest) | Out-Null
            Copy-Item -Force -LiteralPath $Metadata -Destination $MetadataDest
        }
    }

    foreach ($ManagedSkillPath in $ManagedSkillPaths) {
        $ManagedPath = Join-Path $RepoRoot $ManagedSkillPath
        if (Test-Path -LiteralPath $ManagedPath) {
            Remove-Item -Recurse -Force -LiteralPath $ManagedPath
        }
    }
    foreach ($SkillSource in $SkillSources) {
        Copy-Item -Recurse -LiteralPath (Join-Path $PreparedDest $SkillSource.Name) -Destination (Join-Path $Dest $SkillSource.Name)
    }

    Write-Host "Updated $($SkillSources.Count) explicitly selected Matt Pocock skills in $Dest"
    Write-Host "Upstream commit: $UpstreamCommit"
    Write-Host ""
    Write-Host "Review vendored skill changes before committing:"
    Invoke-Git -C $RepoRoot status --short -- external/mattpocock-skills
    Invoke-Git -C $RepoRoot --no-pager diff -- external/mattpocock-skills
} finally {
    Remove-Item -Recurse -Force $Tmp -ErrorAction SilentlyContinue
}
