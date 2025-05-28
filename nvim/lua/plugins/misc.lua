return {
    "nvim-lua/plenary.nvim",
    {
        "nvim-neotest/neotest",
        dependencies = {
            "nvim-neotest/nvim-nio",
            "nvim-lua/plenary.nvim",
            "nvim-neotest/neotest-python",
            "mrcjkb/rustaceanvim",
        },
        config = function()
            require("neotest").setup({
                adapters = {
                    require("neotest-python")({
                        args = { "-v" }, -- get more diff
                    }),
                    require("rustaceanvim.neotest"),
                },
                output = {
                    -- disable pop-up with failing test info (prefer virtual text)
                    open_on_run = false,
                },
                quickfix = {
                    enabled = false,
                },
            })
        end,
        keys = {
            { "<leader>tt", "<CMD>Neotest summary toggle<CR>", desc = "Toggle Neotest" },
            { "<leader>tn", "<CMD>Neotest run<CR>",            desc = "Test Nearest" },
            { "<leader>ts", "<CMD>Neotest stop<CR>",           desc = "Test Stop" },
            { "<leader>tf", "<CMD>Neotest run file<CR>",       desc = "Test File" },
            -- create a command that shows the output of a test with "neotest.output"
            {
                "<leader>to",
                "<CMD>Neotest output<CR>",
                desc = "Toggle Neotest",
            },
            {
                "<leader>td",
                function() require("neotest").run.run({ strategy = "dap" }) end,
                desc = "Test Debug",
            },
        },
        cmd = "Neotest",
    },
    {
        -- install dap
        "mfussenegger/nvim-dap",
        requires = {
            "rcarriga/nvim-dap-ui",
            "theHamsta/nvim-dap-virtual-text",
            "mfussenegger/nvim-dap-python",
            "nvim-telescope/telescope-dap.nvim",
        },
    },
    {
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
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
                filetypes = {
                    typescriptreact = true,
                    python = true,
                    rust = true,
                    markdown = true,
                    go = true,
                    lua = true,
                    typescript = true,
                    javascript = true,
                    html = true,
                    css = true,
                    scss = true,
                    json = true,
                    yaml = true,
                    toml = true,
                },
                copilot_node_command = "/Users/julianramire/.nvm/versions/node/v20.14.0/bin/node"
            })
        end,

    }
}
