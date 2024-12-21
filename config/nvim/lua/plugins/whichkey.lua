-- Installation with Lazy
return {
  'folke/which-key.nvim',
  event = 'VeryLazy',
  opts = {
    preset = 'modern',
  },
  init = function()
    vim.o.timeout = true
    vim.o.timeoutlen = 300
  end,
  dependencies = {
    { 'nvim-tree/nvim-web-devicons' },
  },
  config = function()
    local telescope_builtin = require('telescope.builtin')

    require('which-key').add({
      -- Telescope
      { '<leader>t',  group = 'Telescope' },
      { '<leader>tb', telescope_builtin.buffers,                       desc = 'Open buffers' },
      { '<leader>td', telescope_builtin.lsp_document_symbols,          desc = 'Symbols in document' },
      { '<leader>th', telescope_builtin.help_tags,                     desc = 'Telescope help tags' },
      { '<leader>tm', telescope_builtin.marks,                         desc = 'Telescope marks' },
      { '<leader>to', telescope_builtin.oldfiles,                      desc = 'Recently opened files' },
      { '<leader>ts', telescope_builtin.spell_suggest,                 desc = 'Suggest spelling' },
      { '<leader>tt', '<cmd>TodoTelescope<CR>',                        desc = 'Todo list' },
      { '<leader>tg', telescope_builtin.live_grep,                     desc = 'live grep with ripgrep' },
      { '<leader>tw', telescope_builtin.lsp_dynamic_workspace_symbols, desc = 'Symbols in workspace' },
      { '<leader>tz', '<cmd>Telescope zoxide list<CR>',                desc = 'Zoxide' }
    })
  end,
}
