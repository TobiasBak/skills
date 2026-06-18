param(
    [switch]$Force
)

$ErrorActionPreference = "Stop"

$Dest = Resolve-Path $PSScriptRoot
$RepoRoot = (Resolve-Path (Join-Path $Dest "../..")).Path
$Tmp = Join-Path ([System.IO.Path]::GetTempPath()) ("skills-" + [System.Guid]::NewGuid())
$SkillPaths = @(
    "external/mattpocock-skills/grill-with-docs",
    "external/mattpocock-skills/write-a-skill",
    "external/mattpocock-skills/improve-codebase-architecture",
    "external/mattpocock-skills/tdd"
)

$PendingChanges = git -C $RepoRoot status --short -- $SkillPaths
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
          skills/productivity/write-a-skill `
          skills/engineering/grill-with-docs `
          skills/engineering/improve-codebase-architecture `
          skills/engineering/tdd
    } finally {
        Pop-Location
    }

    @("grill-me", "grill-with-docs", "write-a-skill", "improve-codebase-architecture", "tdd") | ForEach-Object {
        Remove-Item -Recurse -Force (Join-Path $Dest $_) -ErrorAction SilentlyContinue
    }

    Copy-Item -Recurse (Join-Path $Tmp "repo/skills/productivity/write-a-skill") (Join-Path $Dest "write-a-skill")
    Copy-Item -Recurse (Join-Path $Tmp "repo/skills/engineering/grill-with-docs") (Join-Path $Dest "grill-with-docs")
    Copy-Item -Recurse (Join-Path $Tmp "repo/skills/engineering/improve-codebase-architecture") (Join-Path $Dest "improve-codebase-architecture")
    Copy-Item -Recurse (Join-Path $Tmp "repo/skills/engineering/tdd") (Join-Path $Dest "tdd")

    Write-Host "Updated Matt Pocock skills in $Dest"
    Write-Host ""
    Write-Host "Review vendored skill changes before committing:"
    git -C $RepoRoot status --short -- $SkillPaths
    git -C $RepoRoot --no-pager diff -- $SkillPaths
} finally {
    Remove-Item -Recurse -Force $Tmp -ErrorAction SilentlyContinue
}
