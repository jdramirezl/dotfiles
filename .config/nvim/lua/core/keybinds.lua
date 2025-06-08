local map = require("helpers.keys").map

-- General mappings
--------------------------------------------------------------------------------
-- Clipboard operations
map("v", "<leader>y", '"+y', "Copy to system clipboard")
map("n", "<leader>cy", ":%y+<cr>", "Copy entire file to clipboard")

-- Fold management
map("n", "<leader>za", "za", "Toggle fold under cursor")
map("n", "<leader>za", "zM", "Close all folds")

-- Quick escape from insert mode
map("i", "jj", "<esc>", "Exit insert mode")
map("t", "jj", "<C-\\><C-n>", "Exit terminal mode")

-- File and window operations
map("n", "<leader>fw", "<cmd>w<cr>", "Write file")
map("n", "<leader>fa", "<cmd>wa<cr>", "Write all files")
map("n", "<leader>qq", "<cmd>q<cr>", "Quit")
map("n", "<leader>qa", "<cmd>qa!<cr>", "Force quit all")
map("n", "<leader>dw", "<cmd>close<cr>", "Close window")

-- Line navigation
map("n", "<M-h>", "^", "Go to start of line")
map("n", "<M-l>", "$", "Go to end of line")

-- Window navigation
map("n", "<C-h>", "<C-w><C-h>", "Move to left window")
map("n", "<C-j>", "<C-w><C-j>", "Move to window below")
map("n", "<C-k>", "<C-w><C-k>", "Move to window above")
map("n", "<C-l>", "<C-w><C-l>", "Move to right window")

-- File content operations
map("n", "<C-a>", "<Esc>ggVG", "Select entire file")

-- Line movement
map("n", "<A-j>", ":m .+1<CR>==", "Move line down")
map("v", "<A-j>", ":m '>+1<CR>gv=gv", "Move selection down")
map("i", "<A-j>", "<Esc>:m .+1<CR>==gi", "Move line down")
map("n", "<A-k>", ":m .-2<CR>==", "Move line up")
map("v", "<A-k>", ":m '<-2<CR>gv=gv", "Move selection up")
map("i", "<A-k>", "<Esc>:m .-2<CR>==gi", "Move line up")

-- Line duplication
map("n", "<S-k>", "<Esc>yyP", "Duplicate line up")
map("n", "<S-j>", "<Esc>yyp", "Duplicate line down")

-- Buffer management
--------------------------------------------------------------------------------
local buffers = require("helpers.buffers")
map("n", "<leader>db", buffers.delete_this, "Delete current buffer")
map("n", "<leader>do", buffers.delete_others, "Delete other buffers")
map("n", "<leader>da", buffers.delete_all, "Delete all buffers")

-- Buffer navigation
map("n", "<S-l>", ":bnext<CR>", "Next buffer")
map("n", "<S-h>", ":bprevious<CR>", "Previous buffer")

-- Indentation
map("v", "<", "<gv", "Decrease indent and reselect")
map("v", ">", ">gv", "Increase indent and reselect")

-- Search
map("n", "<leader>cs", "<cmd>nohl<cr>", "Clear search highlights")

-- Telescope mappings
--------------------------------------------------------------------------------
local telescope = require("telescope.builtin")
map("n", "<leader>fr", telescope.oldfiles, "Find recently opened files")
map("n", "<leader><space>", telescope.buffers, "Find open buffers")
map("n", "<leader>/", function()
	telescope.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
		winblend = 10,
		previewer = false,
	}))
end, "Fuzzy search in current buffer")
map("n", "<leader>ff", telescope.find_files, "Find files")
map("n", "<leader>fh", telescope.help_tags, "Search help tags")
map("n", "<leader>fd", telescope.grep_string, "Find word under cursor")
map("n", "<leader>fg", telescope.live_grep, "Live grep in workspace")
map("n", "<leader>fb", telescope.buffers, "Find buffers")
map("n", "<C-p>", telescope.keymaps, "Search keymaps")

-- LSP mappings
--------------------------------------------------------------------------------
-- Global diagnostic mappings
vim.keymap.set("n", "<space>e", vim.diagnostic.open_float, { desc = "Show diagnostic details in float" })
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next diagnostic" })
vim.keymap.set("n", "<space>q", vim.diagnostic.setloclist, { desc = "Add diagnostics to location list" })

-- LSP mappings (only applied when LSP server attaches to buffer)
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("UserLspConfig", {}),
	callback = function(ev)
		local opts = { buffer = ev.buf }
		vim.keymap.set(
			"n",
			"gD",
			vim.lsp.buf.declaration,
			vim.tbl_extend("force", opts, { desc = "Go to declaration" })
		)
		vim.keymap.set("n", "gd", vim.lsp.buf.definition, vim.tbl_extend("force", opts, { desc = "Go to definition" }))
		vim.keymap.set("n", "K", vim.lsp.buf.hover, vim.tbl_extend("force", opts, { desc = "Show hover information" }))
		vim.keymap.set(
			"n",
			"gi",
			vim.lsp.buf.implementation,
			vim.tbl_extend("force", opts, { desc = "Go to implementation" })
		)
		vim.keymap.set(
			"n",
			"<C-k>",
			vim.lsp.buf.signature_help,
			vim.tbl_extend("force", opts, { desc = "Show signature help" })
		)
		vim.keymap.set(
			"n",
			"<space>wa",
			vim.lsp.buf.add_workspace_folder,
			vim.tbl_extend("force", opts, { desc = "Add workspace folder" })
		)
		vim.keymap.set(
			"n",
			"<space>wr",
			vim.lsp.buf.remove_workspace_folder,
			vim.tbl_extend("force", opts, { desc = "Remove workspace folder" })
		)
		vim.keymap.set("n", "<space>wl", function()
			print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
		end, vim.tbl_extend("force", opts, { desc = "List workspace folders" }))
		vim.keymap.set(
			"n",
			"<space>D",
			vim.lsp.buf.type_definition,
			vim.tbl_extend("force", opts, { desc = "Go to type definition" })
		)
		vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, vim.tbl_extend("force", opts, { desc = "Rename symbol" }))
		vim.keymap.set(
			{ "n", "v" },
			"<space>ca",
			vim.lsp.buf.code_action,
			vim.tbl_extend("force", opts, { desc = "Code action" })
		)
		vim.keymap.set("n", "gr", vim.lsp.buf.references, vim.tbl_extend("force", opts, { desc = "Find references" }))
		vim.keymap.set("n", "<space>f", function()
			vim.lsp.buf.format({ async = true })
		end, vim.tbl_extend("force", opts, { desc = "Format buffer" }))
	end,
})

-- Nvim-tree mappings
--------------------------------------------------------------------------------
map("n", "<leader>b", "<cmd>NvimTreeToggle<CR>", "Toggle file explorer")

-- Configure nvim-tree preview mappings when tree buffer is active
vim.api.nvim_create_autocmd("FileType", {
	pattern = "NvimTree",
	callback = function(ev)
		local preview = require("nvim-tree-preview")
		local api = require("nvim-tree.api")
		local function opts(desc)
			return { desc = "nvim-tree: " .. desc, buffer = ev.buf, noremap = true, silent = true, nowait = true }
		end

		-- Preview mappings
		vim.keymap.set("n", "P", preview.watch, opts("Preview (Watch)"))
		vim.keymap.set("n", "<Esc>", preview.unwatch, opts("Close Preview/Unwatch"))
		vim.keymap.set("n", "<C-f>", function()
			return preview.scroll(4)
		end, opts("Scroll Down"))
		vim.keymap.set("n", "<C-b>", function()
			return preview.scroll(-4)
		end, opts("Scroll Up"))

		-- Smart tab behavior
		vim.keymap.set("n", "<Tab>", function()
			local ok, node = pcall(api.tree.get_node_under_cursor)
			if ok and node then
				if node.type == "directory" then
					api.node.open.edit()
				else
					preview.node(node, { toggle_focus = true })
				end
			end
		end, opts("Preview/Expand"))
	end,
})

-- Git mappings
--------------------------------------------------------------------------------
map("n", "<leader>l", "<cmd>Neogit<cr>", "Open Git interface")

-- Trouble mappings
--------------------------------------------------------------------------------
map("n", "<leader>xd", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", "Document diagnostics")
map("n", "<leader>xw", "<cmd>Trouble lsp toggle focus=false win.position=right<cr>", "Workspace diagnostics")
map("n", "<leader>xq", "<cmd>Trouble qflist toggle<cr>", "Quickfix list")

-- Linting mappings
--------------------------------------------------------------------------------
vim.keymap.set("n", "[d", "<Plug>(ale_previous_wrap)", { silent = true, desc = "Previous ALE error" })
vim.keymap.set("n", "]d", "<Plug>(ale_next_wrap)", { silent = true, desc = "Next ALE error" })
vim.keymap.set("n", "<leader>;", ":ALELint<CR>", { silent = true, desc = "Run ALE linters" })
vim.keymap.set("n", "gl", ":ALEDetail<CR>", { silent = true, desc = "Show ALE error detail" })

-- Configure diagnostic display
vim.diagnostic.config({
	virtual_text = true,
	signs = true,
	underline = true,
	update_in_insert = false,
	severity_sort = true,
	float = {
		border = "rounded",
		source = "always",
		header = "",
		prefix = "",
		max_width = 100,
		max_height = 20,
	},
})

-- Diagnostic signs
local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
for type, icon in pairs(signs) do
	local hl = "DiagnosticSign" .. type
	vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

-- Testing mappings (Neotest)
--------------------------------------------------------------------------------
map("n", "<leader>tt", "<CMD>Neotest summary toggle<CR>", "Toggle test summary")
map("n", "<leader>tn", "<CMD>Neotest run<CR>", "Run nearest test")
map("n", "<leader>ts", "<CMD>Neotest stop<CR>", "Stop test run")
map("n", "<leader>tf", "<CMD>Neotest run file<CR>", "Run tests in file")
map("n", "<leader>to", "<CMD>Neotest output<CR>", "Show test output")
map("n", "<leader>td", function()
	require("neotest").run.run({ strategy = "dap" })
end, "Debug nearest test")

-- Auto-save mappings
--------------------------------------------------------------------------------
vim.keymap.set("n", "<leader>as", ":ASToggle<CR>", { noremap = true, silent = true, desc = "Toggle auto-save" })

-- Treesitter mappings
--------------------------------------------------------------------------------
-- Incremental selection
vim.keymap.set("n", "gnn", function()
	require("nvim-treesitter.incremental_selection").init_selection()
end, { desc = "Initialize incremental selection" })
vim.keymap.set("n", "grn", function()
	require("nvim-treesitter.incremental_selection").node_incremental()
end, { desc = "Increment selection to larger node" })
vim.keymap.set("n", "grc", function()
	require("nvim-treesitter.incremental_selection").scope_incremental()
end, { desc = "Increment selection to containing scope" })
vim.keymap.set("n", "grm", function()
	require("nvim-treesitter.incremental_selection").node_decremental()
end, { desc = "Shrink selection to smaller node" })

-- Textobject selection
vim.keymap.set({ "o", "x" }, "aa", function()
	require("nvim-treesitter.textobjects.select").select_textobject("@parameter.outer")
end, { desc = "Select around parameter" })
vim.keymap.set({ "o", "x" }, "ia", function()
	require("nvim-treesitter.textobjects.select").select_textobject("@parameter.inner")
end, { desc = "Select inner parameter" })
vim.keymap.set({ "o", "x" }, "af", function()
	require("nvim-treesitter.textobjects.select").select_textobject("@function.outer")
end, { desc = "Select around function" })
vim.keymap.set({ "o", "x" }, "if", function()
	require("nvim-treesitter.textobjects.select").select_textobject("@function.inner")
end, { desc = "Select inner function" })
vim.keymap.set({ "o", "x" }, "ac", function()
	require("nvim-treesitter.textobjects.select").select_textobject("@class.outer")
end, { desc = "Select around class" })
vim.keymap.set({ "o", "x" }, "ic", function()
	require("nvim-treesitter.textobjects.select").select_textobject("@class.inner")
end, { desc = "Select inner class" })

-- Treesitter movement
vim.keymap.set("n", "]m", function()
	require("nvim-treesitter.textobjects.move").goto_next_start("@function.outer")
end, { desc = "Go to next function start" })
vim.keymap.set("n", "]]", function()
	require("nvim-treesitter.textobjects.move").goto_next_start("@class.outer")
end, { desc = "Go to next class start" })
vim.keymap.set("n", "]M", function()
	require("nvim-treesitter.textobjects.move").goto_next_end("@function.outer")
end, { desc = "Go to next function end" })
vim.keymap.set("n", "][", function()
	require("nvim-treesitter.textobjects.move").goto_next_end("@class.outer")
end, { desc = "Go to next class end" })
vim.keymap.set("n", "[m", function()
	require("nvim-treesitter.textobjects.move").goto_previous_start("@function.outer")
end, { desc = "Go to previous function start" })
vim.keymap.set("n", "[[", function()
	require("nvim-treesitter.textobjects.move").goto_previous_start("@class.outer")
end, { desc = "Go to previous class start" })
vim.keymap.set("n", "[M", function()
	require("nvim-treesitter.textobjects.move").goto_previous_end("@function.outer")
end, { desc = "Go to previous function end" })
vim.keymap.set("n", "[]", function()
	require("nvim-treesitter.textobjects.move").goto_previous_end("@class.outer")
end, { desc = "Go to previous class end" })

-- Treesitter swap
local swap_next, swap_prev = (function()
	local swap_objects = {
		p = "@parameter.inner",
		f = "@function.outer",
		c = "@class.outer",
	}

	local n, p = {}, {}
	for key, obj in pairs(swap_objects) do
		n[string.format("<leader>cx%s", key)] = obj
		p[string.format("<leader>cX%s", key)] = obj
	end

	return n, p
end)()

for key, obj in pairs(swap_next) do
	vim.keymap.set("n", key, function()
		require("nvim-treesitter.textobjects.swap").swap_next(obj)
	end, { desc = "Swap with next " .. obj:gsub("@", ""):gsub("%.inner", ""):gsub("%.outer", "") })
end

for key, obj in pairs(swap_prev) do
	vim.keymap.set("n", key, function()
		require("nvim-treesitter.textobjects.swap").swap_previous(obj)
	end, { desc = "Swap with previous " .. obj:gsub("@", ""):gsub("%.inner", ""):gsub("%.outer", "") })
end

-- Git conflict mappings
--------------------------------------------------------------------------------
map("n", "co", "<cmd>GitConflictChooseOurs<cr>", "Choose our version")
map("n", "ct", "<cmd>GitConflictChooseTheirs<cr>", "Choose their version")
map("n", "c0", "<cmd>GitConflictChooseNone<cr>", "Choose neither version")
map("n", "cb", "<cmd>GitConflictChooseBoth<cr>", "Choose both versions")
map("n", "cn", "<cmd>GitConflictNextConflict<cr>", "Go to next conflict")
map("n", "cp", "<cmd>GitConflictPrevConflict<cr>", "Go to previous conflict")

-- Completion (nvim-cmp) mappings
--------------------------------------------------------------------------------
local cmp = require("cmp")
cmp.setup({
	mapping = cmp.mapping.preset.insert({
		["<C-b>"] = cmp.mapping.scroll_docs(-4),
		["<C-f>"] = cmp.mapping.scroll_docs(4),
		["<C-Space>"] = cmp.mapping.complete(),
		["<C-e>"] = cmp.mapping.abort(),
		["<CR>"] = cmp.mapping.confirm({ select = true }),
		["<Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			elseif luasnip.expand_or_jumpable() then
				luasnip.expand_or_jump()
			else
				fallback()
			end
		end, { "i", "s" }),
		["<S-Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
			elseif luasnip.jumpable(-1) then
				luasnip.jump(-1)
			else
				fallback()
			end
		end, { "i", "s" }),
	}),
})

-- Formatting mappings
--------------------------------------------------------------------------------
vim.keymap.set({ "n", "v" }, "<leader>mp", function()
	require("conform").format({
		lsp_fallback = true,
		async = false,
		timeout_ms = 500,
	})
end, { desc = "Format file or range (in visual mode)" })
