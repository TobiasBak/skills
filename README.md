# Skills

Personal collection of reusable Pi coding-agent skills.

## External skills

Selected public skills from:

- https://github.com/mattpocock/skills

Currently vendored:

- `caveman`
- `grill-me`
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

Create a skill directory under `skills/` with a `SKILL.md`, add the skill name to `skills.json`, then rerun the install script.
