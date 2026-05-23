$ErrorActionPreference = "Stop"

$Dest = Resolve-Path $PSScriptRoot
$Tmp = Join-Path ([System.IO.Path]::GetTempPath()) ("skills-" + [System.Guid]::NewGuid())

try {
    git clone --depth 1 --filter=blob:none --sparse https://github.com/mattpocock/skills (Join-Path $Tmp "repo")
    Push-Location (Join-Path $Tmp "repo")
    try {
        git sparse-checkout set --no-cone `
          skills/productivity/caveman `
          skills/productivity/write-a-skill `
          skills/engineering/grill-with-docs `
          skills/engineering/improve-codebase-architecture `
          skills/engineering/tdd
    } finally {
        Pop-Location
    }

    @("caveman", "grill-me", "grill-with-docs", "write-a-skill", "improve-codebase-architecture", "tdd") | ForEach-Object {
        Remove-Item -Recurse -Force (Join-Path $Dest $_) -ErrorAction SilentlyContinue
    }

    Copy-Item -Recurse (Join-Path $Tmp "repo/skills/productivity/caveman") (Join-Path $Dest "caveman")
    Copy-Item -Recurse (Join-Path $Tmp "repo/skills/productivity/write-a-skill") (Join-Path $Dest "write-a-skill")
    Copy-Item -Recurse (Join-Path $Tmp "repo/skills/engineering/grill-with-docs") (Join-Path $Dest "grill-with-docs")
    Copy-Item -Recurse (Join-Path $Tmp "repo/skills/engineering/improve-codebase-architecture") (Join-Path $Dest "improve-codebase-architecture")
    Copy-Item -Recurse (Join-Path $Tmp "repo/skills/engineering/tdd") (Join-Path $Dest "tdd")

    Write-Host "Updated Matt Pocock skills in $Dest"
} finally {
    Remove-Item -Recurse -Force $Tmp -ErrorAction SilentlyContinue
}
