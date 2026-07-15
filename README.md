# Skills

Personal collection of reusable agent skills for Pi, Codex, and the ChatGPT desktop app.

## Required tools

Working on this repository assumes these tools are available locally:

- `git`
- `uv`
- `rg` / ripgrep

On Windows, install ripgrep with winget:

```powershell
winget install --id BurntSushi.ripgrep.MSVC --exact
```

Install uv with winget:

```powershell
winget install --id astral-sh.uv --exact
```

Use whichever terminal you prefer. The repo provides both Bash and PowerShell script entry points where useful, but shell choice is not a repository requirement.

## External skills

### Matt Pocock skills

Engineering and productivity skills from:

- https://github.com/mattpocock/skills

The updater copies selected skill folders under Matt Pocock's upstream `skills/engineering` and `skills/productivity` directories. It excludes `ask-matt`, `resolving-merge-conflicts`, and `setup-matt-pocock-skills`, plus upstream `deprecated`, `in-progress`, `misc`, and `personal` skills.

Currently vendored from those upstream folders:

- `code-review`
- `codebase-design`
- `diagnosing-bugs`
- `domain-modeling`
- `grill-me`
- `grill-with-docs`
- `grilling`
- `handoff`
- `implement`
- `improve-codebase-architecture`
- `prototype`
- `research`
- `tdd`
- `teach`
- `to-spec`
- `to-tickets`
- `triage`
- `wayfinder`
- `writing-great-skills`

Only those skill folders are kept. Root upstream files like `CLAUDE.md`, `CONTEXT.md`, and the upstream `README.md` are intentionally excluded.

## Updating Matt Pocock skills

Bash:

```bash
bash ./external/mattpocock-skills/update.sh
```

PowerShell:

```powershell
./external/mattpocock-skills/update.ps1
```

The update script temporarily sparse-clones the upstream repo, discovers skill folders under `skills/engineering` and `skills/productivity`, copies those skill folders, removes local Matt Pocock skill folders that no longer match that set, then deletes the temporary clone. Until PR 522 lands upstream, it preserves local `agents/openai.yaml` files when upstream has no corresponding metadata and reapplies the dual-harness guidance from `external/mattpocock-skills/patches/`. It also reapplies the local skill-admission guidance unless upstream contains an equivalent section. Once upstream supplies metadata or equivalent dual-harness guidance, the upstream files win for that compatibility behavior.

The updater refuses to overwrite uncommitted local changes in selected vendored skill folders. Review or commit local changes first, or force the update only when you intentionally want to overwrite them:

```bash
bash ./external/mattpocock-skills/update.sh --force
```

```powershell
./external/mattpocock-skills/update.ps1 -Force
```

After updating, review the printed `git diff` before committing the vendored changes.

### OpenAI Docs skill

The official OpenAI Docs skill is vendored from:

- https://github.com/openai/skills/tree/main/skills/.curated/openai-docs

It lives at `external/openai-skills/openai-docs` and includes its upstream license, references, scripts, agents, and assets.

Update it with:

```bash
./external/openai-skills/update.sh
```

```powershell
./external/openai-skills/update.ps1
```

The updater refuses to overwrite uncommitted changes in the vendored skill. Review or commit them first, or use `--force` / `-Force` only when intentionally replacing them with upstream.

After updating, review the printed `git diff` before committing.

## Installing skills into Pi and Codex

By default, the installer links skills into Pi at `~/.pi/agent/skills`:

```bash
bash ./scripts/install-links.sh
```

```powershell
./scripts/install-links.ps1
```

Install skills into Codex at `~/.agents/skills` by overriding `PI_SKILLS_DIR`. Exclude `openai-docs` because current Codex releases already bundle that skill; installing this vendored copy as well creates a duplicate model-visible entry.

```bash
PI_SKILLS_DIR="$HOME/.agents/skills" SKILLS_EXCLUDE="openai-docs" bash ./scripts/install-links.sh --fix
```

```powershell
$env:PI_SKILLS_DIR = Join-Path $HOME ".agents/skills"
$env:SKILLS_EXCLUDE = "openai-docs"
./scripts/install-links.ps1 -Fix
```

Use `PI_SKILLS_DIR` similarly for any alternate target directory. `SKILLS_EXCLUDE` accepts a comma-separated list of skill names that should not be linked. Apply the same value when running `verify-links.ps1` against a filtered target.

Pi also scans `~/.agents/skills`. When both global locations contain a skill with the same name, Pi warns and keeps only the first entry; it does not put both descriptions in model context.

The installer discovers every skill folder with a `SKILL.md` under `skills/*` and `external/*/*`. It links the complete folders, including OpenAI-specific `agents/openai.yaml` metadata used by Codex and the ChatGPT desktop app. Pi reads the portable `SKILL.md` instructions and ignores this additive metadata. With `-Fix`, the installer also removes stale links from the target skill directory.

On Windows, prefer PowerShell. Git Bash symlinks can be seen incorrectly by native Windows/Pi tools.

Strict install/fix:

```powershell
./scripts/install-links.ps1 -Fix
```

Verify links:

```powershell
./scripts/verify-links.ps1
```

## Adding a personal skill

Before adding a personal skill, identify the recurring model weakness, missing workflow discipline, or repeated tool-use habit it compensates for. If that target is vague, improve an existing skill or repo instruction instead.

Create a skill directory under `skills/` with a `SKILL.md` and `agents/openai.yaml`, then rerun the install script. Keep discovery triggers in `SKILL.md.description`; use OpenAI metadata for the display name, short UI description, and a one-sentence starter prompt that explicitly mentions `$skill-name`. If `SKILL.md` sets `disable-model-invocation: true`, also set `policy.allow_implicit_invocation: false` in `agents/openai.yaml`.

Code-affecting skills must include a concise `Verification` section that names the expected verification surface, behavioral coverage guidance, and what to report if only partial verification is possible.
