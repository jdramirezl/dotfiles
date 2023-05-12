return {
    "nvim-lua/plenary.nvim",
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
    -- "tpope/vim-sleuth",  -- Detect tabstop and shiftwidth automatically
    {
        "machakann/vim-sandwich"
    },
}
