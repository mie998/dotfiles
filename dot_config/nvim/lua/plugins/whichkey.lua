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
      -- general search
      { "<leader>'", telescope_builtin.git_status, desc = "Changed files" },
      { "<leader>;", telescope_builtin.find_files, desc = "Find files" },
      { "<leader>?", telescope_builtin.live_grep, desc = "Grep in all files" },

      -- Actions
      { "<leader>a", group = "actions" },
      { "<leader>ab", '"_', desc = "Black hole register" },
      { "<leader>ac", "<cmd>ColorizerToggle<CR>", desc = "Toggle colorizer" },
      { "<leader>ad", 'diwxda"<CR>', desc = "Delete HTML attribute" },
      { "<leader>ae", "<cmd>EslintFixAll<CR>", desc = "Fix all ESLint errors" },
      { "<leader>aK", vim.lsp.buf.hover, desc = "Show hover" },
      { "<leader>ar", vim.cmd.TSRemoveUnused, desc = "Remove unused imports" },
      { "<leader>at", vim.cmd.TSOrganizeImports, desc = "Organize imports" },
      { "<leader>ai", vim.cmd.TSAddImports, desc = "Add imports" },

      -- LSP
      { "<leader>l", group = "LSP", icon = "󰢱" },
      { "<leader>lf", vim.lsp.buf.format, desc = "format document" },
      { "<leader>lh", "<cmd>Lspsaga hover_doc<CR>", desc = "hover diagnostic" },
      { "<leader>lt", "<cmd>Lspsaga term_toggle<CR>", desc = "floaterm", icon = "" },
      { "<leader>lq", "<cmd>Lspsaga finder<CR>", desc = "finder", icon = "󰀶" },

      -- Diagnostics
      { "<leader>e", group = "Diagnostics" },
      { "<leader>ee", "<cmd>Trouble diagnostics toggle<cr>", desc = "Open Trouble list" },
      { "<leader>ed", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Document Diagnostics" },
      { "<leader>eq", "<cmd>Trouble qflist<cr>", desc = "Quickfix" },
      { "<leader>el", "<cmd>Trouble loclist<cr>", desc = "Loclist" },

      -- Telescope
      { '<leader>t', group = 'Telescope' },
      { '<leader>tb', telescope_builtin.buffers, desc = 'Open buffers' },
      { '<leader>td', telescope_builtin.lsp_document_symbols, desc = 'Symbols in document' },
      { '<leader>th', telescope_builtin.help_tags, desc = 'Telescope help tags' },
      { '<leader>tm', telescope_builtin.marks, desc = 'Telescope marks' },
      { '<leader>to', telescope_builtin.oldfiles, desc = 'Recently opened files' },
      { '<leader>ts', telescope_builtin.spell_suggest, desc = 'Suggest spelling' },
      { '<leader>tt', '<cmd>TodoTelescope<CR>', desc = 'Todo list' },
      { '<leader>tg', telescope_builtin.live_grep, desc = 'live grep with ripgrep' },
      { '<leader>tw', telescope_builtin.lsp_dynamic_workspace_symbols, desc = 'Symbols in workspace' },
      { '<leader>tz', '<cmd>Telescope zoxide list<CR>', desc = 'Zoxide' },

      -- buffer control ( barbar.nvim )
      { '<leader>b', group = 'BufferControl' },
      { '<leader>bgt', '<cmd>Telescope zoxide list<CR>', desc = 'Zoxide' },
      { '<leader>bgT', '<cmd>Telescope zoxide list<CR>', desc = 'Zoxide' },
      { '<Leader>bgT', '<Cmd>BufferMovePrevious<CR>' },
      { '<Leader>bgt', '<Cmd>BufferMoveNext<CR>' },
      { '<Leader>b1', '<Cmd>BufferGoto 1<CR>' },
      { '<Leader>b2', '<Cmd>BufferGoto 2<CR>' },
      { '<Leader>b3', '<Cmd>BufferGoto 3<CR>' },
      { '<Leader>b4', '<Cmd>BufferGoto 4<CR>' },
      { '<Leader>b5', '<Cmd>BufferGoto 5<CR>' },
      { '<Leader>b6', '<Cmd>BufferGoto 6<CR>' },
      { '<Leader>b7', '<Cmd>BufferGoto 7<CR>' },
      { '<Leader>b8', '<Cmd>BufferGoto 8<CR>' },
      { '<Leader>b9', '<Cmd>BufferGoto 9<CR>' },
      { '<Leader>b0', '<Cmd>BufferLast<CR>' },
      { '<Leader>bp', '<Cmd>BufferPin<CR>' },
      { '<Leader>bx', '<Cmd>BufferClose<CR>' },
      { '<Leader>bp', '<Cmd>BufferPick<CR>' },
      { '<Leader>bb', '<Cmd>BufferOrderByBufferNumber<CR>' },
      { '<Leader>bn', '<Cmd>BufferOrderByName<CR>' },
      { '<Leader>bd', '<Cmd>BufferOrderByDirectory<CR>' },
      { '<Leader>bl', '<Cmd>BufferOrderByLanguage<CR>' },
      { '<Leader>bw', '<Cmd>BufferOrderByWindowNumber<CR>' },
    })
  end,
}
