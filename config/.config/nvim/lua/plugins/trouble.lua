local icons = require("helpers.icons").diagnostics

-- Pretty list for diagnostics, references, etc.
return {
	{
		"folke/trouble.nvim",
		cmd = { "Trouble", "TroubleToggle" },
		dependencies = "nvim-tree/nvim-web-devicons",
		opts = {
			signs = {
				error = icons.Error,
				warning = icons.Warn,
				hint = icons.Hint,
				information = icons.Info,
			},
			auto_close = true,
			win_config = { border = "rounded" },
		},
	},
}
