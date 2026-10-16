# Bootstrap

## Requirements

- macOS on Apple Silicon or Intel
- Xcode Command Line Tools: `xcode-select --install`
- Git and network access for the initial clone
- Homebrew installed from its official instructions at <https://brew.sh>

Review dependencies before installing them:

```bash
./bin/dotfiles deps check
brew bundle --file ./Brewfile --no-upgrade
```

The Brewfile installs Neovim 0.11+, WezTerm, Starship, mise, shell utilities, validation tools, and FiraCode Nerd Font. Project runtimes remain project-owned. Neovim Mason installs Pyright, rust-analyzer, Debugpy, Prettier, Ruff, and Stylua on first use.

## Install

```bash
./bin/dotfiles check
./bin/dotfiles plan install
./bin/dotfiles install --apply
./bin/dotfiles verify
```

`install --apply` moves conflicting live targets into a timestamped backup and creates absolute symlinks to the repository. Re-running it is idempotent.

## Local configuration

```bash
mkdir -p ~/.config/dotfiles
cp config/.zsh/local.example.zsh ~/.config/dotfiles/local.zsh
chmod 600 ~/.config/dotfiles/local.zsh
```

Put hostnames, employer tooling, account identifiers, Java selection, and private aliases in this file. Never put reusable authentication inputs in shell source; use the tool's secure interactive login or the macOS Keychain.

## Post-install

Restart the terminal, then verify:

```bash
zsh -i -c 'print shell-ready'
nvim
wezterm --config-file ~/.wezterm.lua show-keys --lua >/dev/null
```
