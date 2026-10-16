local wezterm = require("wezterm")

package.path = wezterm.config_dir .. "/?.lua;" .. package.path

local config = wezterm.config_builder()

require("appearance")(config)
require("keys")(config)
require("status")(config)

local local_config = wezterm.config_dir .. "/local.lua"
local ok, local_setup = pcall(dofile, local_config)
if ok and type(local_setup) == "function" then
  local_setup(config)
end

return config
