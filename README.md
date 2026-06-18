# Skills

Personal collection of reusable Pi coding-agent skills.

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

Selected public skills from:

- https://github.com/mattpocock/skills

Currently vendored:

- `grill-with-docs`
- `write-a-skill`
- `improve-codebase-architecture`
- `tdd`

Only the selected skill folders are kept. Root upstream files like `CLAUDE.md`, `CONTEXT.md`, and the upstream `README.md` are intentionally excluded.

## Updating Matt Pocock skills

Bash:

```bash
./external/mattpocock-skills/update.sh
```

PowerShell:

```powershell
./external/mattpocock-skills/update.ps1
```

The update script temporarily sparse-clones the upstream repo, copies only the selected skill folders, then deletes the temporary clone.

The updater refuses to overwrite uncommitted local changes in selected vendored skill folders. Review or commit local changes first, or force the update only when you intentionally want to overwrite them:

```bash
./external/mattpocock-skills/update.sh --force
```

```powershell
./external/mattpocock-skills/update.ps1 -Force
```

After updating, review the printed `git diff` before committing the vendored changes.

## Installing skills into Pi

Bash:

```bash
./scripts/install-links.sh
```

PowerShell:

```powershell
./scripts/install-links.ps1
```

By default, skills are linked into:

```text
~/.pi/agent/skills
```

Override with `PI_SKILLS_DIR` if needed.

The installer links skills listed in `skills.json`.

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

Create a skill directory under `skills/` with a `SKILL.md`, add the skill name to `skills.json`, then rerun the install script.

Code-affecting skills must include a concise `Verification` section that names the expected verification surface, behavioral coverage guidance, and what to report if only partial verification is possible.
