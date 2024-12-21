return {
  'nvimdev/lspsaga.nvim',
  event = "LspAttach",
  config = function()
    require('lspsaga').setup({
      finder = {
        max_height = 0.6,
      },
      ui = {
        border = "rounded",
      }
    })
  end,
  dependencies = {
    'nvim-treesitter/nvim-treesitter',
    'nvim-tree/nvim-web-devicons',
  }
}
