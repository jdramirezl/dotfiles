return {
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      current_line_blame = false,
      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns
        local map = function(lhs, rhs, desc)
          vim.keymap.set("n", lhs, rhs, { buffer = bufnr, desc = desc })
        end
        map("]h", function() if vim.wo.diff then vim.cmd.normal({ "]c", bang = true }) else gs.nav_hunk("next") end end, "Next Git hunk")
        map("[h", function() if vim.wo.diff then vim.cmd.normal({ "[c", bang = true }) else gs.nav_hunk("prev") end end, "Previous Git hunk")
        map("<leader>gp", gs.preview_hunk, "Preview hunk")
        map("<leader>gr", gs.reset_hunk, "Reset hunk")
        map("<leader>gb", gs.blame_line, "Blame line")
      end,
    },
  },
  {
    "NeogitOrg/neogit",
    cmd = "Neogit",
    keys = { { "<leader>gg", "<cmd>Neogit<cr>", desc = "Open Neogit" } },
    dependencies = { "nvim-lua/plenary.nvim", "sindrets/diffview.nvim", "nvim-telescope/telescope.nvim" },
    opts = { integrations = { diffview = true, telescope = true }, graph_style = "unicode" },
  },
  {
    "akinsho/git-conflict.nvim",
    event = "BufReadPre",
    opts = { default_mappings = false, default_commands = true, disable_diagnostics = true },
    keys = {
      { "<leader>gco", "<cmd>GitConflictChooseOurs<cr>", desc = "Choose ours" },
      { "<leader>gct", "<cmd>GitConflictChooseTheirs<cr>", desc = "Choose theirs" },
      { "<leader>gcb", "<cmd>GitConflictChooseBoth<cr>", desc = "Choose both" },
      { "<leader>gcn", "<cmd>GitConflictChooseNone<cr>", desc = "Choose neither" },
      { "]x", "<cmd>GitConflictNextConflict<cr>", desc = "Next conflict" },
      { "[x", "<cmd>GitConflictPrevConflict<cr>", desc = "Previous conflict" },
    },
  },
}
