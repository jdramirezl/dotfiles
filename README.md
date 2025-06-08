# 🚀 My Dotfiles

This repository contains my personal dotfiles and configuration for various development tools. It includes settings for:

- 🛠️ Neovim - Text editor configuration
- 📟 WezTerm - Terminal emulator setup
- 🐚 Zsh - Shell configuration and custom scripts
- ⭐ Starship - Cross-shell prompt

## �� What's Included

- `config/` - All configuration files
  - `.config/`
    - `nvim/` - Neovim configuration
    - `wezterm/` - WezTerm configuration
    - `starship.toml` - Starship prompt configuration
  - `.zsh/` - Custom Zsh scripts and functions
  - `.zshrc` - Main Zsh configuration
  - `.wezterm.lua` - WezTerm main configuration
- `backup_dotfiles.sh` - Automated backup script

## 🔧 Installation

1. Clone this repository:
   ```bash
   git clone https://github.com/jdramirezl/dotfiles.git
   cd dotfiles
   ```

2. Create symbolic links:
   ```bash
   # Neovim
   ln -s $(pwd)/config/.config/nvim ~/.config/nvim

   # WezTerm
   ln -s $(pwd)/config/.wezterm.lua ~/.wezterm.lua
   ln -s $(pwd)/config/.config/wezterm ~/.config/wezterm

   # Zsh
   ln -s $(pwd)/config/.zshrc ~/.zshrc
   ln -s $(pwd)/config/.zsh ~/.zsh

   # Starship
   ln -s $(pwd)/config/.config/starship.toml ~/.config/starship.toml
   ```

## 🔄 Backup

To backup your current configuration:

1. Navigate to the repository:
   ```bash
   cd path/to/dotfiles
   ```

2. Run the backup script:
   ```bash
   ./backup_dotfiles.sh
   ```

The script will:
- Copy all configuration files from their respective locations into the `config/` directory
- Commit the changes with a timestamp
- Push to the repository

## ⚙️ Dependencies

Make sure you have these tools installed:

- [Neovim](https://neovim.io/) - Modern Vim-based text editor
- [WezTerm](https://wezfurlong.org/wezterm/) - GPU-accelerated terminal emulator
- [Zsh](https://www.zsh.org/) - Extended Bourne shell
- [Starship](https://starship.rs/) - Minimal, blazing-fast prompt

## 📝 License

This project is open source and available under the [MIT License](LICENSE).

## 🤝 Contributing

Feel free to submit pull requests or create issues if you have suggestions for improvements! 