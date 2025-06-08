return {
    {
      "nvim-treesitter/nvim-treesitter",
      dependencies = { 
              "nvim-treesitter/nvim-treesitter-textobjects",
              "Djancyp/better-comments.nvim",
          },
      build = ":TSUpdate",
      event = "BufReadPost",
      config = function()
        require("nvim-treesitter.configs").setup {
          ensure_installed = {
            "bash",
            "vimdoc",
            "html",
            "javascript",
            "json",
            "lua",
            "markdown",
            "markdown_inline",
            "python",
            "query",
            "regex",
            "rust",
            "tsx",
            "typescript",
            "vim",
            "yaml",
          },
          highlight = { enable = true },
          indent = { enable = true, disable = { "python" } },
          incremental_selection = {
            enable = true,
          },
          textobjects = {
            select = {
              enable = true,
              lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
            },
            move = {
              enable = true,
              set_jumps = true, -- whether to set jumps in the jumplist
            },
            swap = {
              enable = true,
            },
          },
        }
      end,
    },
  }
  