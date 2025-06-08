local wezterm = require("wezterm")

-- Import configuration modules
local setup_appearance = require("appearance")
local setup_keybindings = require("keys")
local setup_status_bar = require("status")

local config = {}

-- Apply configurations from modules
setup_appearance(config)
setup_keybindings(config)
setup_status_bar(config)

return config
