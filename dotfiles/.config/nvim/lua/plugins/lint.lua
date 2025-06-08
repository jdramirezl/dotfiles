return {
    {
        "dense-analysis/ale",
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            -- Enable ALE
            vim.g.ale_enabled = 1
            
            -- Use quickfix instead of loclist
            vim.g.ale_set_quickfix = 1
            vim.g.ale_set_loclist = 0
            
            -- Set specific linters for Python
            vim.g.ale_linters = {
                python = {'pylint', 'flake8', 'mypy', 'bandit'}
            }

            -- Configure each linter with their config files
            vim.g.ale_python_pylint_options = '--rcfile=' .. vim.fn.expand('~/.config/nvim/linting/.pylintrc')
            vim.g.ale_python_flake8_options = '--config=' .. vim.fn.expand('~/.config/nvim/linting/.flake8')
            vim.g.ale_python_mypy_options = '--config-file=' .. vim.fn.expand('~/.config/nvim/linting/mypy.ini')
            vim.g.ale_python_bandit_options = '-c ' .. vim.fn.expand('~/.config/nvim/linting/bandit.yaml')

            -- Signs for the gutter
            vim.g.ale_sign_error = ''
            vim.g.ale_sign_warning = ''
            
            -- Enable completion (integrates with nvim-cmp)
            vim.g.ale_completion_enabled = 1

            -- Format error messages
            vim.g.ale_echo_msg_format = '[%linter%] %s [%severity%]'

            -- Keep the sign gutter open
            vim.g.ale_sign_column_always = 1

            -- Lint only on save by default
            vim.g.ale_lint_on_text_changed = 'never'
            vim.g.ale_lint_on_insert_leave = 0
            vim.g.ale_lint_on_enter = 0
            vim.g.ale_lint_on_save = 1

            -- Configure hover
            vim.g.ale_hover_cursor = 1
            vim.g.ale_hover_to_floating_preview = 1
            vim.g.ale_floating_preview = 1
            vim.g.ale_floating_window_border = {'│', '─', '╭', '╮', '╯', '╰', '│', '─'}

            -- Virtual text settings
            vim.g.ale_virtualtext_cursor = 1
            vim.g.ale_virtualtext_prefix = '❯ '

            -- Configure linter messages
            vim.g.ale_linter_aliases = {
                python = {'python', 'python3'}
            }

            -- Set message severity by linter
            vim.g.ale_type_map = {
                pylint = {ES = 'WS'}, -- Show style errors as warnings
                flake8 = {ES = 'WS'},
                mypy = {ES = 'E'},    -- Show type errors as errors
                bandit = {ES = 'WS'}  -- Show security issues as warnings
            }
        end,
    }
} 