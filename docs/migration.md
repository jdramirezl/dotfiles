# Migration notes

The October 2026 modernization made the repository authoritative and replaced copy-based deployment with managed symlinks.

## Major changes

- Replaced implicit Zsh glob loading with explicit ordered modules.
- Removed startup cloning through Zinit and package-managed shell plugins through Homebrew.
- Standardized runtime activation on mise; removed duplicate NVM and pyenv initialization.
- Moved machine-specific and work-specific behavior to an ignored local layer.
- Replaced embedded authentication input with secure interactive authentication.
- Rebuilt Neovim around Neovim 0.11, lazy.nvim, native LSP, Ruff, Conform, Telescope, nvim-tree, Neotest, and Catppuccin Mocha.
- Replaced WezTerm's remote status plugin with local event handlers and enabled close confirmation.
- Standardized Starship and WezTerm on Catppuccin Mocha.
- Replaced broad copy/commit/push automation with an allowlisted dry-run-first CLI.

## Previous live files

On first `install --apply`, previous regular targets are preserved under `~/.local/state/dotfiles/backups/<run-id>`. The older standalone Neovim backup remains outside the managed manifest and is not imported.

## Public repository hygiene

Historical revisions may contain machine-specific or work-specific values. Current-tree cleanup does not remove Git history. Rotate any reusable authentication material that may have appeared in older revisions. History rewriting is intentionally outside this migration because it affects shared repository history and requires a separate explicit decision.
