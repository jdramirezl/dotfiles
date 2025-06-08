return {
    {
        "neovim/nvim-lspconfig",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",  -- LSP source for nvim-cmp
            "mason.nvim",
            "mason-lspconfig.nvim",
        },
        config = function()
            -- Setup language servers
            local lspconfig = require('lspconfig')
            local capabilities = require('cmp_nvim_lsp').default_capabilities()

            -- Python configuration
            lspconfig.pyright.setup({
                capabilities = capabilities,
                settings = {
                    python = {
                        analysis = {
                            autoSearchPaths = true,
                            diagnosticMode = "workspace",
                            useLibraryCodeForTypes = true,
                            typeCheckingMode = "basic",
                            venvPath = vim.fn.expand("$HOME/.virtualenvs"), -- Default venvs directory
                            venv = vim.fn.getcwd():match("[^/]+$"), -- Try to use the project name as venv name
                        },
                    },
                },
                before_init = function(_, config)
                    -- Try to find the virtual environment in common locations
                    local venv = vim.fn.finddir("venv", vim.fn.getcwd() .. ";")
                    if venv ~= "" then
                        config.settings.python.pythonPath = vim.fn.fnamemodify(venv .. "/bin/python", ":p")
                    else
                        -- Check for poetry environment
                        local poetry_venv = vim.fn.trim(vim.fn.system("poetry env info -p 2>/dev/null"))
                        if vim.v.shell_error == 0 and poetry_venv ~= "" then
                            config.settings.python.pythonPath = poetry_venv .. "/bin/python"
                        end
                    end
                end,
            })

            -- Configure diagnostics display
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
                },
            })
        end,
    },
}