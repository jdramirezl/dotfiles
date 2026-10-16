# Tool inventory

| Layer | Tool | Owner | Verification |
|---|---|---|---|
| Packages | Homebrew + `Brewfile` | Repository | `brew bundle check --file Brewfile` |
| Shell | Zsh 5.9+ | macOS | `zsh --version` |
| Prompt | Starship | Homebrew | `starship config` |
| Terminal | WezTerm | Homebrew cask | `wezterm show-keys --lua` |
| Editor | Neovim 0.11+ | Homebrew | `nvim --version` |
| Runtime manager | mise | Homebrew | `mise doctor` |
| Search | ripgrep, fd, fzf | Homebrew | `rg --version`, `fd --version`, `fzf --version` |
| Shell UX | eza, zoxide, completion/highlighting plugins | Homebrew | `brew bundle check` |
| Editor tools | Pyright, rust-analyzer, Debugpy, Prettier, Ruff, Stylua | Mason | `:Mason` |
| Editor plugins | lazy.nvim lockfile | Neovim | `:Lazy` |
| Syntax parsers | Treesitter | Neovim | `:checkhealth vim.treesitter` |
| Validation | Bats, ShellCheck, shfmt | Homebrew | `./bin/dotfiles verify` |

## Runtime policy

mise is the only global language runtime manager initialized by the shell. Do not initialize NVM or pyenv concurrently. Projects should pin their own Node, Python, Java, Rust, or Go versions using repository files and mise configuration.

No tmux, csh/tcsh, or primary Fish configuration was found on the source machine, so this repository does not claim to manage them.

## Current-machine exclusions

The source machine also has `autossh`, Graphviz, SQLite, Tcl/Tk, Unison, zlib, and Android command-line tools. They were audited but intentionally excluded from the portable core because they support individual projects or work-specific workflows rather than the shell/editor baseline. Add them to a private `Brewfile.local` if another machine needs them. NVM is intentionally retired in favor of mise, while rust-analyzer is intentionally owned by Neovim Mason rather than Homebrew.

Python tests require pytest in the active project environment. Rust diagnostics use `cargo clippy`, so install a Rust toolchain and Clippy for Rust projects. Clipboard integration uses macOS `pbcopy`/`pbpaste`; Linux users need an appropriate clipboard provider.
