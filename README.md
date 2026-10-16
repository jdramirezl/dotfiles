# macOS development dotfiles

A reproducible, security-conscious setup for Zsh, Starship, WezTerm, and Neovim on macOS. The repository is the source of truth; installation creates managed symlinks so normal edits are immediately reflected here.

## Quick start

```bash
git clone https://github.com/jdramirezl/dotfiles.git ~/dotfiles
cd ~/dotfiles
./bin/dotfiles check
./bin/dotfiles deps check          # inspect missing dependencies
./bin/dotfiles install             # dry-run plan
./bin/dotfiles install --apply     # backup conflicts and create links
./bin/dotfiles verify
```

The installer never stages, commits, pushes, deletes regular files, or silently installs dependencies. Conflicting targets are moved to a timestamped backup under `~/.local/state/dotfiles/backups/` before links are created.

## Managed configuration

| Component | Repository source | Live target |
|---|---|---|
| Neovim | `config/.config/nvim` | `~/.config/nvim` |
| WezTerm modules | `config/.config/wezterm` | `~/.config/wezterm` |
| WezTerm entry point | `config/.wezterm.lua` | `~/.wezterm.lua` |
| Starship | `config/.config/starship.toml` | `~/.config/starship.toml` |
| mise runtimes | `config/.config/mise` | `~/.config/mise` |
| Zsh modules | `config/.zsh` | `~/.zsh` |
| Zsh entry point | `config/.zshrc` | `~/.zshrc` |

Catppuccin Mocha provides a consistent terminal, prompt, and editor palette. Machine-specific and work-specific configuration belongs in `~/.config/dotfiles/local.zsh`, never in the public repository. Start from `config/.zsh/local.example.zsh` and use mode `0600`.

## Operations

```bash
./bin/dotfiles status
./bin/dotfiles plan install
./bin/dotfiles backup
./bin/dotfiles update              # dry run
./bin/dotfiles update --apply
./bin/dotfiles uninstall           # dry run
./bin/dotfiles uninstall --apply
```

See [bootstrap](docs/bootstrap.md), [operations](docs/operations.md), [inventory](docs/inventory.md), and [migration notes](docs/migration.md). An AI agent can follow [`agent-sops/dotfiles-bootstrap-update.sop.md`](agent-sops/dotfiles-bootstrap-update.sop.md).

## Safety model

- A fixed manifest allowlists every managed path.
- Install, sync, update, and uninstall are dry-run by default.
- Existing files are backed up transactionally before linking.
- Sync rejects nested repositories and privacy/secret patterns.
- Git publishing is always a separate, human-reviewed action.
- Real credentials, hosts, employee identifiers, and machine-local paths must remain outside Git.

## Validation

```bash
./bin/dotfiles verify
bats tests/dotfiles.bats
shellcheck bin/dotfiles install.sh backup_dotfiles.sh lib/manifest.sh scripts/secret-check
shfmt -d -i 2 bin/dotfiles install.sh backup_dotfiles.sh lib/manifest.sh scripts/secret-check
```

## License

MIT. See [LICENSE](LICENSE).
