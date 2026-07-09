param(
    [switch]$Force
)

$ErrorActionPreference = "Stop"

$Dest = Resolve-Path $PSScriptRoot
$RepoRoot = (Resolve-Path (Join-Path $Dest "../..")).Path
$Tmp = Join-Path ([System.IO.Path]::GetTempPath()) ("skills-" + [System.Guid]::NewGuid())

try {
    git clone --depth 1 --filter=blob:none --sparse https://github.com/mattpocock/skills (Join-Path $Tmp "repo")
    $UpstreamRepo = Join-Path $Tmp "repo"

    git -C $UpstreamRepo sparse-checkout set --no-cone /skills/engineering/* /skills/productivity/*
    $SkillRoots = @("skills/engineering", "skills/productivity")
    $SkillSources = foreach ($SkillRoot in $SkillRoots) {
        $RootPath = Join-Path $UpstreamRepo $SkillRoot
        if (Test-Path -LiteralPath $RootPath) {
            Get-ChildItem -Directory -LiteralPath $RootPath | Where-Object {
                Test-Path -LiteralPath (Join-Path $_.FullName "SKILL.md")
            } | ForEach-Object {
                [pscustomobject]@{
                    Name = $_.Name
                    UpstreamPath = "$SkillRoot/$($_.Name)"
                    RepoPath = "external/mattpocock-skills/$($_.Name)"
                }
            }
        }
    }
    $SkillSources = @($SkillSources | Sort-Object Name)

    if ($SkillSources.Count -eq 0) {
        Write-Error "No engineering or productivity skills found upstream."
    }

    $Duplicates = @($SkillSources | Group-Object Name | Where-Object { $_.Count -gt 1 })
    if ($Duplicates.Count -gt 0) {
        $Messages = $Duplicates | ForEach-Object {
            $Paths = $_.Group | ForEach-Object { $_.UpstreamPath }
            "Duplicate upstream skill name '$($_.Name)': $($Paths -join ', ')"
        }
        Write-Error ($Messages -join "`n")
    }

    $CurrentSkillPaths = @(
        Get-ChildItem -Directory -LiteralPath $Dest | ForEach-Object {
            "external/mattpocock-skills/$($_.Name)"
        }
    )
    $TargetSkillPaths = @($SkillSources | ForEach-Object { $_.RepoPath })
    $ManagedSkillPaths = @($CurrentSkillPaths + $TargetSkillPaths | Sort-Object -Unique)

    if ($ManagedSkillPaths.Count -gt 0) {
        $PendingChanges = git -C $RepoRoot status --short -- $ManagedSkillPaths
        if ($PendingChanges -and !$Force) {
            Write-Error ("Refusing to overwrite vendored skills with uncommitted local changes:`n" +
                ($PendingChanges -join "`n") +
                "`nReview or commit these changes, then rerun. Use -Force only when you intentionally want to overwrite them.")
        }
    }

    Get-ChildItem -Directory -LiteralPath $Dest | ForEach-Object {
        Remove-Item -Recurse -Force -LiteralPath $_.FullName
    }

    $SkillSources | Sort-Object Name | ForEach-Object {
        Copy-Item -Recurse -LiteralPath (Join-Path $UpstreamRepo $_.UpstreamPath) -Destination (Join-Path $Dest $_.Name)
    }

    Write-Host "Updated $($SkillSources.Count) Matt Pocock engineering and productivity skills in $Dest"
    Write-Host ""
    Write-Host "Review vendored skill changes before committing:"
    git -C $RepoRoot status --short -- external/mattpocock-skills
    git -C $RepoRoot --no-pager diff -- external/mattpocock-skills
} finally {
    Remove-Item -Recurse -Force $Tmp -ErrorAction SilentlyContinue
}
