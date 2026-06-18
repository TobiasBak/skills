param(
    [switch]$Force
)

$ErrorActionPreference = "Stop"

$Dest = Resolve-Path $PSScriptRoot
$RepoRoot = (Resolve-Path (Join-Path $Dest "../..")).Path
$Tmp = Join-Path ([System.IO.Path]::GetTempPath()) ("skills-" + [System.Guid]::NewGuid())
$ManagedSkillPaths = @(
    "external/mattpocock-skills/diagnosing-bugs",
    "external/mattpocock-skills/tdd",
    "external/mattpocock-skills/domain-modeling",
    "external/mattpocock-skills/codebase-design",
    "external/mattpocock-skills/handoff",
    "external/mattpocock-skills/writing-great-skills",
    "external/mattpocock-skills/grilling",
    "external/mattpocock-skills/grill-with-docs",
    "external/mattpocock-skills/improve-codebase-architecture",
    "external/mattpocock-skills/to-prd",
    "external/mattpocock-skills/write-a-skill"
)

$PendingChanges = git -C $RepoRoot status --short -- $ManagedSkillPaths
if ($PendingChanges -and !$Force) {
    Write-Error ("Refusing to overwrite vendored skills with uncommitted local changes:`n" +
        ($PendingChanges -join "`n") +
        "`nReview or commit these changes, then rerun. Use -Force only when you intentionally want to overwrite them.")
}

try {
    git clone --depth 1 --filter=blob:none --sparse https://github.com/mattpocock/skills (Join-Path $Tmp "repo")
    Push-Location (Join-Path $Tmp "repo")
    try {
        git sparse-checkout set --no-cone `
          skills/productivity/handoff `
          skills/productivity/writing-great-skills `
          skills/productivity/grilling `
          skills/engineering/diagnosing-bugs `
          skills/engineering/tdd `
          skills/engineering/domain-modeling `
          skills/engineering/codebase-design `
          skills/engineering/grill-with-docs `
          skills/engineering/improve-codebase-architecture `
          skills/engineering/to-prd
    } finally {
        Pop-Location
    }

    @("diagnosing-bugs", "tdd", "domain-modeling", "codebase-design", "handoff", "writing-great-skills", "grilling", "grill-with-docs", "improve-codebase-architecture", "to-prd", "grill-me", "write-a-skill") | ForEach-Object {
        Remove-Item -Recurse -Force (Join-Path $Dest $_) -ErrorAction SilentlyContinue
    }

    Copy-Item -Recurse (Join-Path $Tmp "repo/skills/productivity/handoff") (Join-Path $Dest "handoff")
    Copy-Item -Recurse (Join-Path $Tmp "repo/skills/productivity/writing-great-skills") (Join-Path $Dest "writing-great-skills")
    Copy-Item -Recurse (Join-Path $Tmp "repo/skills/productivity/grilling") (Join-Path $Dest "grilling")
    Copy-Item -Recurse (Join-Path $Tmp "repo/skills/engineering/diagnosing-bugs") (Join-Path $Dest "diagnosing-bugs")
    Copy-Item -Recurse (Join-Path $Tmp "repo/skills/engineering/tdd") (Join-Path $Dest "tdd")
    Copy-Item -Recurse (Join-Path $Tmp "repo/skills/engineering/domain-modeling") (Join-Path $Dest "domain-modeling")
    Copy-Item -Recurse (Join-Path $Tmp "repo/skills/engineering/codebase-design") (Join-Path $Dest "codebase-design")
    Copy-Item -Recurse (Join-Path $Tmp "repo/skills/engineering/grill-with-docs") (Join-Path $Dest "grill-with-docs")
    Copy-Item -Recurse (Join-Path $Tmp "repo/skills/engineering/improve-codebase-architecture") (Join-Path $Dest "improve-codebase-architecture")
    Copy-Item -Recurse (Join-Path $Tmp "repo/skills/engineering/to-prd") (Join-Path $Dest "to-prd")

    Write-Host "Updated Matt Pocock skills in $Dest"
    Write-Host ""
    Write-Host "Review vendored skill changes before committing:"
    git -C $RepoRoot status --short -- $ManagedSkillPaths
    git -C $RepoRoot --no-pager diff -- $ManagedSkillPaths
} finally {
    Remove-Item -Recurse -Force $Tmp -ErrorAction SilentlyContinue
}
