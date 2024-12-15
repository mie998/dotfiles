return {
  'nvimdev/lspsaga.nvim',
  config = function()
    require('lspsaga').setup({
      finder = {
        keys = {
          jump_to = 'p',
          edit = { 'o', '<CR>' },
          vsplit = 's',
          split = 'i',
          tabe = 't',
          quit = { 'q', '<ESC>' },
        },
      },
      definition = {
        keys = {
          edit = '<C-c>o',
          vsplit = '<C-c>v',
          split = '<C-c>i',
          tabe = '<C-c>t',
          quit = 'q',
        },
      },
      keymap = {
        hover = "gh",
        diagnostic_jump_prev = "[e",
        diagnostic_jump_next = "]e",
        code_action = "<leader>ca",
        -- finder = "<leader>gf",
        peek_definition = "gd",
        rename = "<leader>rn",
        outline = "<leader>o",
        callhierarchy = "<leader>ci",
        diagnostic_jump = "<leader>e",
        toggle_outline = "<leader>o",
      },
    })
  end,
  dependencies = {
    'nvim-treesitter/nvim-treesitter',
    'nvim-tree/nvim-web-devicons',
  }
}

