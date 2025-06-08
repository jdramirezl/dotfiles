return {
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
    cmd = "Neotest",
}