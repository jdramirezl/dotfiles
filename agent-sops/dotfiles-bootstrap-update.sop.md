# Dotfiles Bootstrap and Update

## Overview

This SOP guides an agent through auditing, installing, synchronizing, updating, validating, or uninstalling this macOS dotfiles repository while preserving user data and preventing accidental publication of secrets.

## Parameters

- **repo_path** (required): Absolute path to the checked-out dotfiles repository.
- **operation** (required): One of `audit`, `install`, `sync`, `update`, `uninstall`, or `deps`.
- **apply** (optional, default: `false`): Whether approved filesystem or dependency changes may be applied.
- **backup_dir** (optional): Explicit directory for an additional snapshot before mutation.

**Constraints for parameter acquisition:**
- If all required parameters are already provided, You MUST proceed to the Steps
- If any required parameters are missing, You MUST ask for them before proceeding
- When asking for parameters, You MUST request all parameters in a single prompt
- When asking for parameters, You MUST use the exact parameter names as defined

## Steps

### 1. Establish scope
Resolve the repository and requested operation before running commands.

**Constraints:**
- You MUST confirm that `repo_path/bin/dotfiles` and `repo_path/lib/manifest.sh` exist.
- You MUST treat `apply=false` as read-only because filesystem and package mutations require explicit authorization.
- You MUST NOT infer approval for dependency installation from approval for configuration linking because they have different system impacts.

### 2. Produce a read-only plan
Run deterministic safety checks and generate the requested operation plan.

**Constraints:**
- You MUST run `repo_path/bin/dotfiles check`.
- For `install` or `sync`, You MUST run `repo_path/bin/dotfiles plan operation`.
- For `deps`, You MUST run `repo_path/bin/dotfiles deps check`.
- For `update`, You MUST run `repo_path/bin/dotfiles update` without `--apply`.
- For `uninstall`, You MUST run `repo_path/bin/dotfiles uninstall` without `--apply`.
- For `audit`, You MUST run `repo_path/bin/dotfiles status` and `repo_path/bin/dotfiles verify`.
- You MUST stop on secret findings, nested Git metadata, unsupported platforms, missing manifest sources, escaping paths, or foreign links because continuing could expose data or overwrite unmanaged files.

### 3. Independently verify safety
Compare the plan with the manifest before mutation.

**Constraints:**
- You SHOULD dispatch an independent read-only verifier subagent when one is available.
- You MUST confirm that every planned source is beneath `repo_path/config` and every target is beneath `$HOME`.
- You MUST confirm that no step stages, commits, pushes, rewrites history, or accesses credential stores because Git publication and credential handling are outside this SOP.
- You MUST confirm that deletion targets are repository-owned symlinks before uninstalling.

### 4. Obtain mutation approval
Present the exact effects when `apply=false`.

**Constraints:**
- You MUST report planned links, backups, package/network operations, and removals.
- If mutation is needed and `apply=false`, You MUST ask for approval and stop.
- You MUST NOT describe a dry run as an installation because no live state changed.

### 5. Execute one operation
Run only the repository command corresponding to the approved operation.

**Constraints:**
- For `install`, You MUST run `repo_path/bin/dotfiles install --apply`.
- For `sync`, You MUST run `repo_path/bin/dotfiles sync --apply`.
- For `update`, You MUST run `repo_path/bin/dotfiles update --apply`.
- For `uninstall`, You MUST run `repo_path/bin/dotfiles uninstall --apply`.
- For `deps`, You MUST run `repo_path/bin/dotfiles deps install`.
- If `backup_dir` is provided, You MUST run `repo_path/bin/dotfiles backup --output backup_dir` before mutation.
- You MUST NOT manually copy or remove managed paths because bypassing the manifest defeats transactional safeguards.

### 6. Validate the outcome
Verify configuration behavior and repository safety after execution.

**Constraints:**
- You MUST run `repo_path/bin/dotfiles check` and `repo_path/bin/dotfiles verify`.
- You MUST run `bats repo_path/tests/dotfiles.bats` when Bats is installed.
- You SHOULD run ShellCheck and shfmt when available.
- You MUST compare actual changed targets with the approved plan.
- On validation failure, You MUST stop and report the backup run ID; You MUST NOT improvise destructive cleanup because the transaction record is the recovery source of truth.

### 7. Report reviewed Git commands
Summarize outcomes without publishing repository changes.

**Constraints:**
- You MUST report changed paths, validation results, backup IDs, and unresolved drift.
- You MUST provide `git status --short` and `git diff --check` as manual review commands.
- You MUST NOT stage, commit, or push because repository publication requires separate explicit user direction and review.

## Examples

### Fresh installation preview

- **repo_path**: `/path/to/dotfiles`
- **operation**: `install`
- **apply**: `false`

The agent runs checks and displays the install plan, then stops before mutation.

### Approved update

- **repo_path**: `/path/to/dotfiles`
- **operation**: `update`
- **apply**: `true`

The agent updates declared dependencies and editor tooling, then runs all validation steps without publishing Git changes.

## Troubleshooting

### Foreign link detected

Do not replace it automatically. Identify its owner and ask the user whether it should be migrated or excluded.

### Secret check fails

Move private values to `~/.config/dotfiles/local.zsh`, rotate exposed reusable credentials, and rerun the check. Never print the secret value.

### Installation validation fails

Use the backup ID printed by the installer and its `transaction.tsv` to restore exact prior targets. Do not choose a backup by recency alone.
