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

The updater copies only the skill folders listed below from Matt Pocock's upstream `skills/engineering` and `skills/productivity` directories, plus the explicitly admitted `skills/in-progress/batch-grill-me`. Every other upstream skill is excluded.

Currently vendored from those upstream folders:

- `batch-grill-me`
- `grill-with-docs`
- `handoff`
- `to-spec`
- `to-tickets`

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

The update script temporarily sparse-clones exactly the five upstream paths listed above, copies them, removes local Matt Pocock skill folders outside that allowlist, then deletes the temporary clone. Future upstream folders are never discovered or admitted automatically. Local `agents/openai.yaml` files remain locally owned and are restored over upstream metadata so explicit prompts and invocation policy survive refreshes. Maintained overlays keep `grill-with-docs` independent of excluded skills and keep `to-spec`/`to-tickets` independent of Matt's excluded setup skill. All overlays are validated before vendored folders are replaced; if an upstream change makes one fail, the updater stops without altering the vendored set.

The updater refuses to overwrite uncommitted local changes in selected vendored skill folders. Review or commit local changes first, or force the update only when you intentionally want to overwrite them:

```bash
bash ./external/mattpocock-skills/update.sh --force
```

```powershell
./external/mattpocock-skills/update.ps1 -Force
```

After updating, review the printed `git diff` before committing the vendored changes.

## Installing skills into Pi and Codex

By default, the installer links skills into Pi at `~/.pi/agent/skills`:

```bash
bash ./scripts/install-links.sh
```

```powershell
./scripts/install-links.ps1
```

Install skills into Codex at `~/.agents/skills` by overriding `PI_SKILLS_DIR`.

```bash
PI_SKILLS_DIR="$HOME/.agents/skills" bash ./scripts/install-links.sh --fix
```

```powershell
$env:PI_SKILLS_DIR = Join-Path $HOME ".agents/skills"
./scripts/install-links.ps1 -Fix
```

Use `PI_SKILLS_DIR` similarly for any alternate target directory. `SKILLS_EXCLUDE` optionally accepts a comma-separated list of skill names that should not be linked; apply the same value when running `verify-links.ps1` against a filtered target.

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
