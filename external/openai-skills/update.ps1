param(
    [switch]$Force
)

$ErrorActionPreference = "Stop"
$Dest = $PSScriptRoot
$RepoRoot = (Resolve-Path (Join-Path $Dest "../..")).Path
$SkillPath = "external/openai-skills/openai-docs"
$Tmp = Join-Path ([System.IO.Path]::GetTempPath()) ("openai-skills-" + [System.Guid]::NewGuid())

try {
    $PendingChanges = git -C $RepoRoot status --short -- $SkillPath
    if ($PendingChanges -and !$Force) {
        Write-Error ("Refusing to overwrite the vendored OpenAI Docs skill with uncommitted local changes:`n" +
            ($PendingChanges -join "`n") +
            "`nReview or commit these changes, then rerun. Use -Force only when you intentionally want to overwrite them.")
    }

    git clone --depth 1 --filter=blob:none --sparse https://github.com/openai/skills (Join-Path $Tmp "repo")
    $UpstreamRepo = Join-Path $Tmp "repo"
    git -C $UpstreamRepo sparse-checkout set --no-cone /skills/.curated/openai-docs

    $Source = Join-Path $UpstreamRepo "skills/.curated/openai-docs"
    if (!(Test-Path -LiteralPath (Join-Path $Source "SKILL.md"))) {
        Write-Error "OpenAI Docs skill not found upstream."
    }

    $Target = Join-Path $Dest "openai-docs"
    Remove-Item -Recurse -Force $Target -ErrorAction SilentlyContinue
    Copy-Item -Recurse -LiteralPath $Source -Destination $Target

    Write-Host "Updated OpenAI Docs skill in $Target"
    Write-Host ""
    Write-Host "Review vendored skill changes before committing:"
    git -C $RepoRoot status --short -- $SkillPath
    git -C $RepoRoot --no-pager diff -- $SkillPath
} finally {
    Remove-Item -Recurse -Force $Tmp -ErrorAction SilentlyContinue
}
