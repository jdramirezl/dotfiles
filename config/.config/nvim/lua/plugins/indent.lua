return {
    "nvimdev/indentmini.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
        char = "│",  -- indent line character
        exclude = {  -- filetypes to exclude
            "help",
            "dashboard",
            "nvim-tree",
            "mason",
            "lazy",
            "TelescopePrompt",
            "TelescopeResults",
        },
        minlevel = 1,  -- minimum indent level to show indent lines
        only_current = false,  -- only show indent line for current range
    },
    config = function(_, opts)
        require("indentmini").setup(opts)

        -- Set up indent line colors based on your colorscheme
        vim.cmd.highlight("IndentLine guifg=#3b4261")  -- Regular indent lines
        vim.cmd.highlight("IndentLineCurrent guifg=#7aa2f7")  -- Current indent line
    end,
}
