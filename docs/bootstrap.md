# Bootstrap

## Requirements

- macOS on Apple Silicon or Intel
- Xcode Command Line Tools: `xcode-select --install`
- Git and network access for the initial clone
- Homebrew installed from its official instructions at <https://brew.sh>

Review dependency profiles before installing them:

```bash
./bin/dotfiles deps check --profile core
./bin/dotfiles deps check --profile desktop
./bin/dotfiles deps check --profile hardware
./bin/dotfiles deps install --profile all
```

`all` installs core and desktop dependencies. Hardware remains separate because DisplayLink installs a system extension and may require macOS approval, logout, or restart:

```bash
./bin/dotfiles deps install --profile hardware --confirm-hardware
```

The core Brewfile installs Neovim 0.11+, WezTerm, Starship, mise, shell utilities, validation tools, and FiraCode Nerd Font. The desktop profile installs Rectangle, Superwhisper, VS Code, browsers, communication tools, media tools, Obsidian, and Anki. Superwhisper is the portable replacement for the internal Wisp app and can keep transcription and prompt cleanup local on Apple Silicon. Project runtimes remain project-owned. Neovim Mason installs Pyright, rust-analyzer, Debugpy, Prettier, Ruff, and Stylua on first use.

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
