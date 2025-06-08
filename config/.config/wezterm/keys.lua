local wezterm = require("wezterm")

local function setup_keybindings(config)
    config.keys = {
        -- Tab management
        {
            key = 'LeftArrow',
            mods = 'CMD',
            action = wezterm.action.ActivateTabRelative(-1),  -- Previous tab
        },
        {
            key = 'RightArrow',
            mods = 'CMD',
            action = wezterm.action.ActivateTabRelative(1),   -- Next tab
        },
        {
            key = 't',
            mods = 'CMD',
            action = wezterm.action.SpawnTab 'CurrentPaneDomain',  -- New tab
        },
        -- Direct tab switching (CMD + number)
        {
            key = '1',
            mods = 'CMD',
            action = wezterm.action.ActivateTab(0),
        },
        {
            key = '2',
            mods = 'CMD',
            action = wezterm.action.ActivateTab(1),
        },
        {
            key = '3',
            mods = 'CMD',
            action = wezterm.action.ActivateTab(2),
        },
        {
            key = '4',
            mods = 'CMD',
            action = wezterm.action.ActivateTab(3),
        },
        {
            key = '5',
            mods = 'CMD',
            action = wezterm.action.ActivateTab(4),
        },
        -- Split panes
        {
            key = 'd',
            mods = 'CMD',
            action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' },
        },
        {
            key = 'D',
            mods = 'CMD|SHIFT',
            action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' },
        },
        -- Close current pane
        {
            key = 'w',
            mods = 'CMD',
            action = wezterm.action.CloseCurrentPane { confirm = false },
        },
        -- Navigate between panes
        {
            key = 'h',
            mods = 'CMD|SHIFT',
            action = wezterm.action.ActivatePaneDirection 'Left',
        },
        {
            key = 'l',
            mods = 'CMD|SHIFT',
            action = wezterm.action.ActivatePaneDirection 'Right',
        },
        {
            key = 'k',
            mods = 'CMD|SHIFT',
            action = wezterm.action.ActivatePaneDirection 'Up',
        },
        {
            key = 'j',
            mods = 'CMD|SHIFT',
            action = wezterm.action.ActivatePaneDirection 'Down',
        },
        -- VI mode activation (CTRL+[)
        {
            key = '[',
            mods = 'CTRL',
            action = wezterm.action.ActivateCopyMode,
        },
        -- Quick select mode
        {
            key = 'f',
            mods = 'CTRL|SHIFT',
            action = wezterm.action.QuickSelect,
        },
        -- Adjust pane size
        {
            key = 'LeftArrow',
            mods = 'CMD|SHIFT',
            action = wezterm.action.AdjustPaneSize { 'Left', 5 },
        },
        {
            key = 'RightArrow',
            mods = 'CMD|SHIFT',
            action = wezterm.action.AdjustPaneSize { 'Right', 5 },
        },
        {
            key = 'UpArrow',
            mods = 'CMD|SHIFT',
            action = wezterm.action.AdjustPaneSize { 'Up', 5 },
        },
        {
            key = 'DownArrow',
            mods = 'CMD|SHIFT',
            action = wezterm.action.AdjustPaneSize { 'Down', 5 },
        },
    }

    -- Mouse bindings
    config.mouse_bindings = {
        -- Right click copies the selection and pastes
        {
            event = { Down = { streak = 1, button = "Right" } },
            mods = "NONE",
            action = wezterm.action.CopyMode "ClearSelectionMode",
        },
    }
end

return setup_keybindings 