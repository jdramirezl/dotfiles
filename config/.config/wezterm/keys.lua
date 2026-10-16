local wezterm = require("wezterm")
local action = wezterm.action

return function(config)
  local primary = wezterm.target_triple:find("darwin") and "CMD" or "CTRL|SHIFT"

  config.keys = {
    { key = "LeftArrow", mods = primary, action = action.ActivateTabRelative(-1) },
    { key = "RightArrow", mods = primary, action = action.ActivateTabRelative(1) },
    { key = "t", mods = primary, action = action.SpawnTab("CurrentPaneDomain") },
    { key = "d", mods = primary, action = action.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
    { key = "D", mods = primary .. "|SHIFT", action = action.SplitVertical({ domain = "CurrentPaneDomain" }) },
    { key = "w", mods = primary, action = action.CloseCurrentPane({ confirm = true }) },
    { key = "LeftArrow", mods = "SHIFT|" .. primary, action = action.ActivatePaneDirection("Left") },
    { key = "RightArrow", mods = "SHIFT|" .. primary, action = action.ActivatePaneDirection("Right") },
    { key = "UpArrow", mods = "SHIFT|" .. primary, action = action.ActivatePaneDirection("Up") },
    { key = "DownArrow", mods = "SHIFT|" .. primary, action = action.ActivatePaneDirection("Down") },
    { key = "LeftArrow", mods = "CTRL|SHIFT", action = action.AdjustPaneSize({ "Left", 5 }) },
    { key = "RightArrow", mods = "CTRL|SHIFT", action = action.AdjustPaneSize({ "Right", 5 }) },
    { key = "UpArrow", mods = "CTRL|SHIFT", action = action.AdjustPaneSize({ "Up", 5 }) },
    { key = "DownArrow", mods = "CTRL|SHIFT", action = action.AdjustPaneSize({ "Down", 5 }) },
    { key = "x", mods = primary .. "|SHIFT", action = action.ActivateCopyMode },
    { key = "f", mods = "CTRL|SHIFT", action = action.QuickSelect },
    { key = "p", mods = primary .. "|SHIFT", action = action.ActivateCommandPalette },
  }

  for index = 1, 8 do
    table.insert(config.keys, {
      key = tostring(index),
      mods = primary,
      action = action.ActivateTab(index - 1),
    })
  end
end
