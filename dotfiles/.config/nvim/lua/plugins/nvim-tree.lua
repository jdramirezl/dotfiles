return {
    "nvim-tree/nvim-tree.lua",
    dependencies = {
        "nvim-tree/nvim-web-devicons",
        "nvim-lua/plenary.nvim",
        "3rd/image.nvim",
        "b0o/nvim-tree-preview.lua",
q    },
    opts = {
        view = {
            float = {
                enable = true,
                quit_on_focus_loss = true,
                open_win_config = function()
                    local screen_w = vim.opt.columns:get()
                    local screen_h = vim.opt.lines:get() - vim.opt.cmdheight:get()
                    local window_w = screen_w * 0.5
                    local window_h = screen_h * 0.8
                    local window_w_int = math.floor(window_w)
                    local window_h_int = math.floor(window_h)
                    local center_x = (screen_w - window_w) / 2
                    local center_y = ((vim.opt.lines:get() - window_h) / 2) - vim.opt.cmdheight:get()
                    return {
                        border = "rounded",
                        relative = "editor",
                        row = center_y,
                        col = center_x,
                        width = window_w_int,
                        height = window_h_int,
                    }
                end,
            },
        },
        on_attach = function(bufnr)
            local api = require('nvim-tree.api')

            -- Set up default mappings
            api.config.mappings.default_on_attach(bufnr)

            local function opts(desc)
                return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
            end

            local preview = require('nvim-tree-preview')

            -- Preview mappings
            vim.keymap.set('n', 'P', preview.watch, opts('Preview (Watch)'))
            vim.keymap.set('n', '<Esc>', preview.unwatch, opts('Close Preview/Unwatch'))
            vim.keymap.set('n', '<C-f>', function() return preview.scroll(4) end, opts('Scroll Down'))
            vim.keymap.set('n', '<C-b>', function() return preview.scroll(-4) end, opts('Scroll Up'))

            -- Smart tab behavior: Preview files, expand/collapse directories
            vim.keymap.set('n', '<Tab>', function()
                local ok, node = pcall(api.tree.get_node_under_cursor)
                if ok and node then
                    if node.type == 'directory' then
                        api.node.open.edit()
                    else
                        preview.node(node, { toggle_focus = true })
                    end
                end
            end, opts('Preview/Expand'))
        end,
    },
}
