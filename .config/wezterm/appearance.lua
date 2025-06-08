local wezterm = require("wezterm")

local function setup_appearance(config)
    -- Basic appearance
    config.color_scheme = "Catppuccin Frappe"
    config.font = wezterm.font('FiraCode Nerd Font')
    config.font_size = 15.0
    
    -- Window appearance
    config.enable_tab_bar = true
    config.hide_tab_bar_if_only_one_tab = false
    config.use_fancy_tab_bar = false
    config.tab_bar_at_bottom = true
    config.window_close_confirmation = "NeverPrompt"
    
    -- Terminal appearance
    config.default_cursor_style = 'SteadyBar'
    config.animation_fps = 60
    config.cursor_blink_rate = 800
    config.scrollback_lines = 10000
    config.window_background_opacity = 0.85
    config.macos_window_background_blur = 10

    -- Window padding
    config.window_padding = {
        left = 0,
        right = 0,
        top = 0,
        bottom = 0,
    }
end

return setup_appearance 