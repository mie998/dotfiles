vim.cmd("autocmd!")

-- leader
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- esc
vim.keymap.set("i", "jj", "<Esc>")

-- exit terminal mode
vim.keymap.set('t', '<Esc>', "<C-\\><C-n><C-w>h",{silent = true})

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

-- buffer control with barbar.nvim
vim.keymap.set('n', 'gT', '<Cmd>BufferPrevious<CR>')
vim.keymap.set('n', 'gt', '<Cmd>BufferNext<CR>')
vim.keymap.set('n', '<Leader>bgT', '<Cmd>BufferMovePrevious<CR>')
vim.keymap.set('n', '<Leader>bgt', '<Cmd>BufferMoveNext<CR>')
vim.keymap.set('n', '<Leader>b1', '<Cmd>BufferGoto 1<CR>')
vim.keymap.set('n', '<Leader>b2', '<Cmd>BufferGoto 2<CR>')
vim.keymap.set('n', '<Leader>b3', '<Cmd>BufferGoto 3<CR>')
vim.keymap.set('n', '<Leader>b4', '<Cmd>BufferGoto 4<CR>')
vim.keymap.set('n', '<Leader>b5', '<Cmd>BufferGoto 5<CR>')
vim.keymap.set('n', '<Leader>b6', '<Cmd>BufferGoto 6<CR>')
vim.keymap.set('n', '<Leader>b7', '<Cmd>BufferGoto 7<CR>')
vim.keymap.set('n', '<Leader>b8', '<Cmd>BufferGoto 8<CR>')
vim.keymap.set('n', '<Leader>b9', '<Cmd>BufferGoto 9<CR>')
vim.keymap.set('n', '<Leader>b0', '<Cmd>BufferLast<CR>')
vim.keymap.set('n', '<Leader>bp', '<Cmd>BufferPin<CR>')
vim.keymap.set('n', '<Leader>bx', '<Cmd>BufferClose<CR>')
vim.keymap.set('n', '<Leader>bp', '<Cmd>BufferPick<CR>')
vim.keymap.set('n', '<Leader>bb', '<Cmd>BufferOrderByBufferNumber<CR>')
vim.keymap.set('n', '<Leader>bn', '<Cmd>BufferOrderByName<CR>')
vim.keymap.set('n', '<Leader>bd', '<Cmd>BufferOrderByDirectory<CR>')
vim.keymap.set('n', '<Leader>bl', '<Cmd>BufferOrderByLanguage<CR>')
vim.keymap.set('n', '<Leader>bw', '<Cmd>BufferOrderByWindowNumber<CR>')
