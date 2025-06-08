#!/bin/bash

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Print with color
print_status() {
    echo -e "${GREEN}[+]${NC} $1"
}

print_error() {
    echo -e "${RED}[!]${NC} $1"
}

# Create backup directories
create_dirs() {
    print_status "Creating backup directories..."
    mkdir -p config/.config/{nvim,wezterm}
    mkdir -p config/.zsh
}

# Copy dotfiles
copy_files() {
    print_status "Copying dotfiles..."
    
    # Neovim
    if [ -d "$HOME/.config/nvim" ]; then
        cp -R "$HOME/.config/nvim" "config/.config/"
        print_status "Copied Neovim configuration"
    else
        print_error "Neovim config not found"
    fi

    # WezTerm
    if [ -f "$HOME/.wezterm.lua" ]; then
        cp "$HOME/.wezterm.lua" "config/"
        print_status "Copied WezTerm configuration"
    fi
    if [ -d "$HOME/.config/wezterm" ]; then
        cp -R "$HOME/.config/wezterm" "config/.config/"
        print_status "Copied WezTerm directory"
    fi

    # Zsh files
    if [ -f "$HOME/.zshrc" ]; then
        cp "$HOME/.zshrc" "config/"
        print_status "Copied .zshrc"
    fi
    if [ -d "$HOME/.zsh" ]; then
        cp -R "$HOME/.zsh/"* "config/.zsh/"
        print_status "Copied .zsh directory"
    fi

    # Starship
    if [ -f "$HOME/.config/starship.toml" ]; then
        cp "$HOME/.config/starship.toml" "config/.config/"
        print_status "Copied Starship configuration"
    fi
}

# Git operations
git_operations() {
    print_status "Performing git operations..."

    # Add all changes including this script
    git add .
    
    # Create commit with timestamp
    git commit -m "Update dotfiles: $(date '+%Y-%m-%d %H:%M:%S')"
    
    # Push to master
    if git push origin master; then
        print_status "Successfully pushed to repository"
    else
        print_error "Failed to push to repository"
        return 1
    fi
}

# Main execution
main() {
    # Ensure we're in the right directory
    if [[ ! -d ".git" ]]; then
        print_error "Please run this script from the dotfiles repository root"
        exit 1
    fi
    
    create_dirs
    copy_files
    git_operations
}

main 