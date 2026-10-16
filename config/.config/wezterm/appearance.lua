local wezterm = require("wezterm")

return function(config)
  config.color_scheme = "Catppuccin Mocha"
  config.font = wezterm.font_with_fallback({ "FiraCode Nerd Font", "JetBrains Mono", "Menlo" })
  config.font_size = 15.0
  config.enable_tab_bar = true
  config.hide_tab_bar_if_only_one_tab = false
  config.use_fancy_tab_bar = false
  config.tab_bar_at_bottom = true
  config.show_new_tab_button_in_tab_bar = false
  config.tab_max_width = 32
  config.window_close_confirmation = "AlwaysPrompt"
  config.default_cursor_style = "SteadyBar"
  config.animation_fps = 60
  config.cursor_blink_rate = 800
  config.scrollback_lines = 10000
  config.window_background_opacity = 0.92
  config.window_decorations = "RESIZE"
  config.window_padding = { left = 6, right = 6, top = 4, bottom = 4 }

  if wezterm.target_triple:find("darwin") then
    config.macos_window_background_blur = 16
  end
end
