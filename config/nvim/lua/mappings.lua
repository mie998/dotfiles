vim.cmd("autocmd!")

-- leader
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- esc
vim.keymap.set("i", "jj", "<Esc>")

-- fastmove
vim.keymap.set("n", "<S-k>", "10k")
vim.keymap.set("n", "<S-j>", "10j")
vim.keymap.set("n", "<S-h>", "10h")
vim.keymap.set("n", "<S-l>", "10l")

-- split
vim.keymap.set("n", "ss", ":split<Return><C-w>w")
vim.keymap.set("n", "sv", ":vsplit<Return><C-w>w")

-- change active windows
vim.keymap.set("n", "sh", "<C-w>h")
vim.keymap.set("n", "sk", "<C-w>k")
vim.keymap.set("n", "sj", "<C-w>j")
vim.keymap.set("n", "sl", "<C-w>l")
