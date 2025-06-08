-- >>>>>> Init
vim.cmd('autocmd!')
vim.loader.enable()

-- >>>>>> Bootstrap
local set          = vim.opt

-- >>>>>> General settings
vim.scriptencoding = 'utf-8'
vim.clipboard      = 'unnamedplus'
--vim.opt.termguicolors = true

-- >>>>>> Global
vim.g.mapleader    = ' ' -- Space: ' '

-- >>>>>> Window scoped
vim.wo.number      = true

-- >>>>>> Global, window and buffer settings
-- Basic
set.cc             = "120" -- set a column border for good coding style


-- Encodings
set.encoding     = 'utf-8'
set.fileencoding = 'utf-8'

-- Title
set.title        = true

-- Indentation
set.autoindent   = true
set.smartindent  = true
set.shiftwidth   = 4                 -- width for autoindents
set.softtabstop  = 4                 -- see multiple spaces as tabstops so <BS> does the right thing
vim.cmd('filetype plugin indent on') -- allows auto-indenting depending on file type

-- Cursor
set.relativenumber = true -- relate line number
set.cursorline = true     -- Highlight current position

-- New panes
set.splitright = true
set.splitbelow = true

-- Tab
set.tabstop = 4 -- number of columns occupied by a tab character
set.expandtab = true -- converts tabs to white space
set.list = true -- Show whitespace characters
set.listchars:append({ tab = "»·", trail = "·" }) -- Customize the display of whitespace characters


-- Search
set.showmatch = true  -- show matching brackets.
set.hlsearch = true   -- highlight search results
set.joinspaces = false
set.ignorecase = true -- case insensitive matching

-- Wild Menu
set.wildmenu = true
set.wildmode = "longest:full,full" -- get bash-like tab completions

-- Mouse settings
set.mouse = "a" -- Enable mouse click
-- set.pastetoggle = "<MiddleMouse>" -- Paste with middle click
