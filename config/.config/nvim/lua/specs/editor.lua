return {
  {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    cmd = "Telescope",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
        cond = function() return vim.fn.executable("make") == 1 end,
      },
    },
    keys = {
      { "<leader>ff", function() require("telescope.builtin").find_files({ hidden = true }) end, desc = "Find files" },
      { "<leader>fg", function()
          if vim.fn.executable("rg") == 0 then
            vim.notify("Telescope live grep requires ripgrep (rg)", vim.log.levels.WARN)
            return
          end
          require("telescope.builtin").live_grep()
        end, desc = "Live grep" },
      { "<leader>fr", function() require("telescope.builtin").oldfiles() end, desc = "Recent files" },
      { "<leader>fh", function() require("telescope.builtin").help_tags() end, desc = "Help tags" },
      { "<leader>fk", function() require("telescope.builtin").keymaps() end, desc = "Keymaps" },
      { "<leader>fw", function() require("telescope.builtin").grep_string() end, desc = "Find word under cursor" },
      { "<leader>sb", function()
          require("telescope.builtin").current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({ previewer = false }))
        end, desc = "Search current buffer" },
      { "<leader><space>", function() require("telescope.builtin").buffers() end, desc = "Buffers (compatibility)" },
    },
    opts = {
      defaults = {
        border = true,
        dynamic_preview_title = true,
        layout_config = { prompt_position = "top" },
        sorting_strategy = "ascending",
        mappings = { i = { ["<C-u>"] = false } },
      },
    },
    config = function(_, opts)
      local telescope = require("telescope")
      telescope.setup(opts)
      pcall(telescope.load_extension, "fzf")
    end,
  },
  {
    "nvim-tree/nvim-tree.lua",
    cmd = { "NvimTreeToggle", "NvimTreeFindFile" },
    keys = {
      { "<leader>e", "<cmd>NvimTreeToggle<cr>", desc = "Toggle file tree" },
      { "<leader>E", "<cmd>NvimTreeFindFile<cr>", desc = "Reveal file in tree" },
    },
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      disable_netrw = true,
      hijack_netrw = true,
      respect_buf_cwd = true,
      sync_root_with_cwd = true,
      update_focused_file = { enable = true, update_root = false },
      view = { side = "left", width = 38, preserve_window_proportions = true },
      renderer = {
        group_empty = true,
        highlight_git = "name",
        highlight_opened_files = "name",
        indent_markers = { enable = true },
        icons = { show = { file = true, folder = true, folder_arrow = true, git = true } },
      },
      filters = { dotfiles = false, git_ignored = false },
      git = { enable = true, ignore = false, timeout = 400 },
      diagnostics = { enable = true, show_on_dirs = true },
      actions = { open_file = { quit_on_open = false, resize_window = true } },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "master",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = { "nvim-treesitter/nvim-treesitter-textobjects" },
    opts = {
      ensure_installed = { "bash", "css", "html", "javascript", "json", "lua", "markdown", "markdown_inline", "python", "query", "rust", "tsx", "typescript", "vim", "vimdoc", "yaml" },
      auto_install = false,
      highlight = { enable = true, disable = function(_, buf) return vim.b[buf].bigfile end },
      indent = { enable = true, disable = { "python" } },
      incremental_selection = {
        enable = true,
        keymaps = { init_selection = "<C-Space>", node_incremental = "<C-Space>", scope_incremental = false, node_decremental = "<BS>" },
      },
      textobjects = {
        select = {
          enable = true,
          lookahead = true,
          keymaps = { ["aa"] = "@parameter.outer", ["ia"] = "@parameter.inner", ["af"] = "@function.outer", ["if"] = "@function.inner", ["ac"] = "@class.outer", ["ic"] = "@class.inner" },
        },
        move = {
          enable = true,
          set_jumps = true,
          goto_next_start = { ["]f"] = "@function.outer", ["]c"] = "@class.outer" },
          goto_previous_start = { ["[f"] = "@function.outer", ["[c"] = "@class.outer" },
        },
        swap = {
          enable = true,
          swap_next = { ["<leader>csp"] = "@parameter.inner", ["<leader>csf"] = "@function.outer", ["<leader>csc"] = "@class.outer" },
          swap_previous = { ["<leader>csP"] = "@parameter.inner", ["<leader>csF"] = "@function.outer", ["<leader>csC"] = "@class.outer" },
        },
      },
    },
    config = function(_, opts) require("nvim-treesitter.configs").setup(opts) end,
  },
  {
    "echasnovski/mini.nvim",
    version = false,
    event = "VeryLazy",
    config = function()
      require("mini.comment").setup()
      require("mini.pairs").setup()
      require("mini.indentscope").setup({ symbol = "│", options = { try_as_border = true } })
    end,
  },
  {
    "RRethy/vim-illuminate",
    event = { "BufReadPost", "BufNewFile" },
    opts = { delay = 250, large_file_cutoff = 2000, providers = { "lsp", "treesitter", "regex" } },
    config = function(_, opts) require("illuminate").configure(opts) end,
  },
  {
    "folke/trouble.nvim",
    cmd = "Trouble",
    keys = {
      { "<leader>db", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Buffer diagnostics" },
      { "<leader>dw", "<cmd>Trouble diagnostics toggle<cr>", desc = "Workspace diagnostics" },
      { "<leader>dq", "<cmd>Trouble qflist toggle<cr>", desc = "Quickfix list" },
      { "[q", function() if require("trouble").is_open() then require("trouble").prev({ skip_groups = true, jump = true }) else vim.cmd.cprev() end end, desc = "Previous trouble/quickfix item" },
      { "]q", function() if require("trouble").is_open() then require("trouble").next({ skip_groups = true, jump = true }) else vim.cmd.cnext() end end, desc = "Next trouble/quickfix item" },
    },
    opts = { focus = true },
  },
}
