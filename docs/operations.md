# Operations

## Status and drift

`./bin/dotfiles status` reports whether each target is correctly linked. Because links make the repository authoritative, normal edits require no import step.

`./bin/dotfiles sync` exists only for migration from legacy regular files. It previews changes by default, imports only manifest paths with `--apply`, rejects sensitive content and nested `.git` directories, and performs no Git operation.

## Backups and recovery

`./bin/dotfiles backup` snapshots all manifest targets to `~/.local/state/dotfiles/snapshots/<timestamp>`. Install conflict backups are stored in `~/.local/state/dotfiles/backups/<run-id>` with `transaction.tsv` describing each prior target.

If installation fails, the script restores changed targets automatically. For manual recovery, inspect the transaction file and move the named backup back to its original target after removing only the repository-owned symlink.

## Updates

Preview first:

```bash
./bin/dotfiles update
```

Apply deliberately:

```bash
./bin/dotfiles update --apply
```

This reconciles Brewfile dependencies, mise runtimes, lazy.nvim plugins, Mason tools, and Treesitter parsers, then runs verification. Review `git status` and `git diff` afterward because plugin updates may change `lazy-lock.json`.

## Git review

The management CLI never stages or publishes changes. Review explicitly:

```bash
git status --short
git diff --check
git diff
```

Commit only reviewed paths. Publishing remains a separate manual action.

## Uninstall

`./bin/dotfiles uninstall` prints a plan. With `--apply`, it removes only links that resolve to this exact repository; regular files and foreign links are untouched.
