local map = require("helpers.keys").map

-- Map copy to clipboard to <leader>y
map("v", "<leader>y", '"+y')

-- Copy the entire file content
map("n", "<leader>cy", ":%y+<cr>")

-- Open and close folds
map("n", "<leader>za", "za", "Toggle fold")
map("n", "<leader>za", "zM", "Close all folds")

-- Blazingly fast way out of insert mode
map("i", "jj", "<esc>")
map("t", "jj", "<C-\\><C-n>")

-- Quick access to some common actions
map("n", "<leader>fw", "<cmd>w<cr>", "Write")
map("n", "<leader>fa", "<cmd>wa<cr>", "Write all")
map("n", "<leader>qq", "<cmd>q<cr>", "Quit")
map("n", "<leader>qa", "<cmd>qa!<cr>", "Quit all")
map("n", "<leader>dw", "<cmd>close<cr>", "Window")

-- Easier access to beginning and end of lines
map("n", "<M-h>", "^", "Go to beginning of line")
map("n", "<M-l>", "$", "Go to end of line")

-- Better window navigation
map("n", "<C-h>", "<C-w><C-h>", "Navigate windows to the left")
map("n", "<C-j>", "<C-w><C-j>", "Navigate windows down")
map("n", "<C-k>", "<C-w><C-k>", "Navigate windows up")
map("n", "<C-l>", "<C-w><C-l>", "Navigate windows to the right")

-- Select entire file
map("n", "<C-a>", "<Esc>ggVG")

-- Move Lines
map("n", "<A-j>", ":m .+1<CR>==")
map("v", "<A-j>", ":m '>+1<CR>gv=gv")
map("i", "<A-j>", "<Esc>:m .+1<CR>==gi")
map("n", "<A-k>", ":m .-2<CR>==")
map("v", "<A-k>", ":m '<-2<CR>gv=gv")
map("i", "<A-k>", "<Esc>:m .-2<CR>==gi")

-- Duplicate lines, vscode like
map("n", "<S-k>", "<Esc>yyP")
map("n", "<S-j>", "<Esc>yyp")


-- Deleting buffe
local buffers = require("helpers.buffers")
map("n", "<leader>db", buffers.delete_this, "Current buffer")
map("n", "<leader>do", buffers.delete_others, "Other buffers")
map("n", "<leader>da", buffers.delete_all, "All buffers")

-- Navigate buffers
map("n", "<S-l>", ":bnext<CR>")
map("n", "<S-h>", ":bprevious<CR>")

-- Stay in indent mode
map("v", "<", "<gv")
map("v", ">", ">gv")

-- Clear after search
map("n", "<leader>cs", "<cmd>nohl<cr>", "Clear highlights")

-- Open Neogit
map("n", "<leader>l", "<cmd>Neogit<cr>", "Open Neogit")
