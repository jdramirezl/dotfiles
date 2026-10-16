return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1000,
    opts = {
      flavour = "mocha",
      background = { light = "latte", dark = "mocha" },
      transparent_background = false,
      term_colors = true,
      dim_inactive = { enabled = false },
      styles = {
        comments = { "italic" },
        conditionals = { "italic" },
        functions = { "bold" },
        keywords = { "italic" },
      },
      integrations = {
        cmp = true,
        dap = true,
        dap_ui = true,
        diffview = true,
        fidget = true,
        gitsigns = true,
        mason = true,
        mini = { enabled = true },
        native_lsp = { enabled = true },
        neotest = true,
        notify = true,
        nvimtree = true,
        snacks = true,
        telescope = { enabled = true },
        treesitter = true,
        trouble = true,
        which_key = true,
      },
      custom_highlights = function(colors)
        return {
          NormalFloat = { bg = colors.mantle },
          FloatBorder = { fg = colors.surface1, bg = colors.mantle },
          FloatTitle = { fg = colors.lavender, bg = colors.mantle, bold = true },
          CursorLine = { bg = colors.surface0 },
          ColorColumn = { bg = colors.mantle },
        }
      end,
    },
    config = function(_, opts)
      require("catppuccin").setup(opts)
      vim.cmd.colorscheme("catppuccin-mocha")
    end,
  },
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
      bigfile = { enabled = true },
      dashboard = {
        enabled = true,
        preset = {
          keys = {
            { icon = " ", key = "f", desc = "Find file", action = ":Telescope find_files" },
            { icon = " ", key = "r", desc = "Recent files", action = ":Telescope oldfiles" },
            { icon = " ", key = "g", desc = "Grep text", action = ":Telescope live_grep" },
            { icon = " ", key = "c", desc = "Open config", action = ":edit $MYVIMRC" },
            { icon = "󰒲 ", key = "l", desc = "Plugin manager", action = ":Lazy" },
            { icon = " ", key = "q", desc = "Quit", action = ":qa" },
          },
        },
      },
      notifier = { enabled = true, timeout = 3000 },
      quickfile = { enabled = true },
      statuscolumn = { enabled = false },
      words = { enabled = false },
    },
  },
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      options = {
        theme = "catppuccin",
        globalstatus = true,
        component_separators = { left = "│", right = "│" },
        section_separators = { left = "", right = "" },
        disabled_filetypes = { statusline = { "dashboard", "snacks_dashboard" } },
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch", "diff" },
        lualine_c = { { "filename", path = 1, symbols = { modified = " ●", readonly = " " } } },
        lualine_x = { "diagnostics", "lsp_status", "filetype" },
        lualine_y = { "progress" },
        lualine_z = { "location" },
      },
      extensions = { "lazy", "mason", "nvim-tree", "quickfix", "trouble" },
    },
  },
  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = {
      { "<leader>bb", "<cmd>Telescope buffers<cr>", desc = "Choose buffer" },
      { "<leader>bp", "<cmd>BufferLinePick<cr>", desc = "Pick buffer" },
    },
    opts = {
      options = {
        always_show_bufferline = false,
        diagnostics = "nvim_lsp",
        offsets = { { filetype = "NvimTree", text = "Explorer", highlight = "Directory", separator = true } },
        separator_style = "slant",
      },
    },
  },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    keys = { { "<leader>?", function() require("which-key").show({ global = false }) end, desc = "Buffer-local keymaps" } },
    opts = {
      delay = 300,
      icons = { mappings = true },
      spec = {
        { "<leader>b", group = "Buffers" },
        { "<leader>c", group = "Code" },
        { "<leader>d", group = "Diagnostics" },
        { "<leader>f", group = "Find" },
        { "<leader>g", group = "Git" },
        { "<leader>q", group = "Quit" },
        { "<leader>s", group = "Search" },
        { "<leader>t", group = "Tests" },
        { "<leader>u", group = "UI and tools" },
        { "<leader>w", group = "Windows and write" },
        { "<leader>y", group = "Yank" },
        { "<leader>z", group = "Folds" },
      },
    },
  },
  {
    "sphamba/smear-cursor.nvim",
    event = "VeryLazy",
    opts = {
      smear_between_neighbor_lines = false,
      smear_insert_mode = false,
      scroll_buffer_space = true,
    },
    cond = function()
      return not vim.env.SSH_CONNECTION and vim.env.TERM ~= "dumb"
    end,
  },
}
