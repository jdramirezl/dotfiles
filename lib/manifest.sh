#!/usr/bin/env bash

manifest_entries() {
  local config_home="${XDG_CONFIG_HOME:-$HOME/.config}"
  printf '%s\t%s\n' \
    "config/.config/nvim" "$config_home/nvim" \
    "config/.config/wezterm" "$config_home/wezterm" \
    "config/.config/starship.toml" "$config_home/starship.toml" \
    "config/.config/mise" "$config_home/mise" \
    "config/.wezterm.lua" "$HOME/.wezterm.lua" \
    "config/.zshrc" "$HOME/.zshrc" \
    "config/.zsh" "$HOME/.zsh"
}
