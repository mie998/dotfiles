return {
  'nvim-telescope/telescope.nvim',
  dependencies = { 'nvim-lua/plenary.nvim' },
  event = 'VeryLazy',
  opts = {
    defaults = {
      vimgrep_arguments = {
        "rg",
        "--color=never",
        "--no-heading",
        "--with-filename",
        "--line-number",
        "--column",
        "--smart-case",
        "--hidden",
      },
    },
  },
  keys = {
    { '<leader>g', function()
      -- glob_patternオプションを引数で指定
      require('telescope.builtin').live_grep({ glob_pattern = '!.git' })
    end },
  },
}
