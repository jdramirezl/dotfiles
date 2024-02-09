return {
    "nvim-lua/plenary.nvim",
    {
        "nvim-neotest/neotest",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter",
            "antoinemadec/FixCursorHold.nvim",
            "folke/neodev.nvim",
            "nvim-neotest/neotest-python"
        },
        keys = {
            {
                "<leader>tl",
                function()
                    require("neotest").run.run_last()
                end,
                desc = "Run Last Test",
            },
            {
                "<leader>tL",
                function()
                    require("neotest").run.run_last({ strategy = "dap" })
                end,
                desc = "Debug Last Test",
            },
            {
                "<leader>tw",
                "<cmd>lua require('neotest').run.run({ jestCommand = 'jest --watch ' })<cr>",
                desc = "Run Watch",
            },
        },
        config = function()
            require('neotest').setup {
                adapters = {
                    require("neotest-python")
                },

            }
        end
        -- mappings = {
        --     run_all = '<Leader>ta',
        --     run_file = '<Leader>tf',
        --     run_nearest = '<Leader>tn',
        --     run_last = '<Leader>tl',
        --     run_suite = '<Leader>ts',
        --     toggle_results = '<Leader>tt',
    },
    {
        "lukas-reineke/indent-blankline.nvim",
        event = "BufReadPre",
        config = true,
    },
    -- Comment with haste
    {
        "numToStr/Comment.nvim",
        opts = {},
    },
    -- {
    --     "folke/neodev.nvim", opts = {},
    -- },
    {
        "machakann/vim-sandwich"
    },
    {
        "zbirenbaum/copilot.lua",
        cmd = "Copilot",
        event = "InsertEnter",
        config = function()
            require("copilot").setup({
                suggestion = {
                    enabled = true,
                    auto_trigger = true,
                    debounce = 75,
                    keymap = {
                        accept = "<C-y>",
                        accept_word = false,
                        accept_line = false,
                        next = "<M-]>",
                        prev = "<M-[>",
                        dismiss = "<M-'>",
                    },
                },
                copilot_node_command = "/Users/julianramire/.nvm/versions/node/v20.2.0/bin/node"
            })
        end,

    }
}
