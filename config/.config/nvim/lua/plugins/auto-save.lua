return {
	{
		"pocco81/auto-save.nvim",
		event = { "InsertLeave", "TextChanged" },
		config = function()
			require("auto-save").setup({
				enabled = true,
				-- Message displayed when auto-save occurs
				execution_message = {
					message = function()
						return ("AutoSave: " .. vim.fn.strftime("%H:%M:%S"))
					end,
					dim = 0.18,
					cleaning_interval = 1250,
				},
				-- Events that trigger auto-save
				trigger_events = { "InsertLeave", "TextChanged" },
				-- Condition to determine if auto-save should occur
				condition = function(buf)
					local utils = require("auto-save.utils.data")
					if
						vim.fn.getbufvar(buf, "&modifiable") == 1
						and utils.not_in(vim.fn.getbufvar(buf, "&filetype"), {
							-- Add filetypes to exclude here
							"TelescopePrompt",
							"neo-tree",
							"dashboard",
							"lazy",
						})
					then
						return true
					end
					return false
				end,
				write_all_buffers = false,
				debounce_delay = 135,
			})
		end,
	},
}
