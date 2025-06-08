-- Fancier statusline
return {
    "nvim-lualine/lualine.nvim",
    config = function()
        require('lualine').setup({
            options = {
                section_separators = '', component_separators = '|',
            },
            sections = {
                -- left
                lualine_a = { 'mode' },
                lualine_b = { 'branch', 'diff', 'diagnostics' },
                lualine_c = { 'filename' },

                -- right
                -- lualine_x = { 'g:zoom#statustext', 'encoding', 'fileformat', 'filetype' },
                -- add lualine_x with custom icon
                lualine_x = { { 'g:zoom#statustext', icon = '' }, 'encoding', {
                    'fileformat',
                    symbols = { unix = '¯\\_(ツ)_/¯', dos = '', mac = '' },
                }, 'filetype' },
                lualine_y = { 'progress' },
                lualine_z = { 'location' }
            },
            extensions = { 'fugitive', 'fzf' },
        })
    end,
}
