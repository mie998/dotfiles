-- open gitui via Floaterm
vim.api.nvim_set_keymap(
  'n',
  '<leader>tg',
  ':FloatermNew --height=0.8 --width=0.8 --wintype=float gitui<CR>',
  { noremap = true, silent = true }
)

vim.api.nvim_set_keymap(
  'n',
  '<leader>tk',
  ':FloatermKill<CR>',
  { noremap = true, silent = true }
)

return {
  'voldikss/vim-floaterm'
}
