local wezterm = require("wezterm")

wezterm.on("format-tab-title", function(tab)
  local title = tab.active_pane.title
  if #title > 28 then
    title = wezterm.truncate_right(title, 28) .. "…"
  end
  return {
    { Background = { Color = tab.is_active and "#313244" or "#1e1e2e" } },
    { Foreground = { Color = tab.is_active and "#cba6f7" or "#a6adc8" } },
    { Text = " " .. (tab.tab_index + 1) .. ": " .. title .. " " },
  }
end)

wezterm.on("update-right-status", function(window, pane)
  local workspace = window:active_workspace()
  local process = pane:get_foreground_process_name():match("([^/]+)$") or "shell"
  window:set_right_status(wezterm.format({
    { Foreground = { Color = "#89b4fa" } },
    { Text = "  " .. workspace .. "  " },
    { Foreground = { Color = "#a6adc8" } },
    { Text = process .. "  " .. wezterm.strftime("%H:%M") .. " " },
  }))
end)

return function(config)
  config.status_update_interval = 1000
end
