local wezterm = require("wezterm")

-- Status bar with powerline style fade
local function setup_status_bar(config)
    -- Use the bar plugin instead of custom implementation
    local bar = wezterm.plugin.require("https://github.com/adriankarlen/bar.wezterm")
    bar.apply_to_config(config)
end

return setup_status_bar 