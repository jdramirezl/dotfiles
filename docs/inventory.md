# Tool inventory

## Core profile

| Layer | Tools | Owner |
|---|---|---|
| Packages | Homebrew + `Brewfile` | Repository |
| Shell | Zsh 5.9+, Starship, eza, zoxide (`z`), fzf | macOS/Homebrew |
| Terminal | WezTerm + FiraCode Nerd Font | Homebrew casks |
| Editor | Neovim 0.11+, ripgrep, fd | Homebrew |
| Runtime manager | mise | Homebrew |
| Runtimes | Node 20.20.2; Python 3.15.0 and 3.12.12 | mise |
| CLI utilities | bat, jq, yq, git-delta, GitHub CLI, Git LFS | Homebrew |
| Editor tools | Pyright, rust-analyzer, Debugpy, Prettier, Ruff, Stylua | Mason |
| Validation | Bats Core, ShellCheck, shfmt | Homebrew |

## Desktop profile

`Brewfile.desktop` installs:

- Superwhisper for local/offline voice-to-text and prompt formatting
- Rectangle for window management
- Visual Studio Code
- Firefox and Google Chrome
- Obsidian
- Slack and Discord
- Spotify and VLC
- Zoom
- Anki

Android Studio, Bruno, and JetBrains Toolbox are intentionally omitted. Employer-managed software and internal applications are never included in the public repository.

## Hardware profile

`Brewfile.hardware` contains DisplayLink only. It is isolated because installation can add a system extension and require Privacy & Security approval, logout, or restart. The CLI requires the explicit `--confirm-hardware` flag for installation.

## Runtime policy

mise is the only global runtime manager initialized by the shell. NVM and pyenv are not initialized because using multiple owners for Node or Python causes PATH-dependent behavior. Projects should pin their own runtime versions when they differ from the global defaults.

No tmux, csh/tcsh, or primary Fish configuration was found on the source machine, so this repository does not claim to manage them.

## Current-machine exclusions

The source machine also has `autossh`, Graphviz, SQLite, Tcl/Tk, Unison, zlib, Android command-line tools, and employer-managed applications. They were audited but intentionally excluded because they support individual projects, hardware, or work-specific workflows. Add personal exceptions to ignored `Brewfile.local`. Rust-analyzer is owned by Neovim Mason rather than Homebrew.

Python tests require pytest in the active project environment. Rust diagnostics use `cargo clippy`, so Rust projects need a Rust toolchain and Clippy. Clipboard integration uses macOS `pbcopy`/`pbpaste`.

## Verification

```bash
./bin/dotfiles deps check --profile core
./bin/dotfiles deps check --profile desktop
./bin/dotfiles deps check --profile hardware
./bin/dotfiles verify
```
