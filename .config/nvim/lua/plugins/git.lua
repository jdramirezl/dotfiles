-- Git related plugins
return {
	{
		"lewis6991/gitsigns.nvim",

		config = function()
			require("gitsigns").setup({
				signs = {
					add = { hl = "GitSignsAdd", text = "│", numhl = "GitSignsAddNr", linehl = "GitSignsAddLn" },
					change = {
						hl = "GitSignsChange",
						text = "│",
						numhl = "GitSignsChangeNr",
						linehl = "GitSignsChangeLn",
					},
					delete = {
						hl = "GitSignsDelete",
						text = "_",
						numhl = "GitSignsDeleteNr",
						linehl = "GitSignsDeleteLn",
					},
					topdelete = {
						hl = "GitSignsDelete",
						text = "‾",
						numhl = "GitSignsDeleteNr",
						linehl = "GitSignsDeleteLn",
					},
					changedelete = {
						hl = "GitSignsChange",
						text = "~",
						numhl = "GitSignsChangeNr",
						linehl = "GitSignsChangeLn",
					},
					untracked = { hl = "GitSignsAdd", text = "┆", numhl = "GitSignsAddNr", linehl = "GitSignsAddLn" },
				},
			})
		end,
	},
	{
		"akinsho/git-conflict.nvim",
		commit = "2957f74",
		config = function()
			require("git-conflict").setup({
				default_mappings = false, -- Disable default mappings as we have them in keybinds.lua
			})
		end,
	},
	{
		"TimUntersberger/neogit",
		cmd = "Neogit",
		config = function()
			require("neogit").setup({
				kind = "split", -- opens neogit in a split
				signs = {
					-- { CLOSED, OPENED }
					section = { "", "" },
					item = { "", "" },
					hunk = { "", "" },
				},
				integrations = { diffview = true }, -- adds integration with diffview.nvim
			})
		end,
	},
}
