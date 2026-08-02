vim.cmd("autocmd!")

-- When config is not present, and opts is, Lazy calls the plugin’s setup automatically, passing opts as the argument.
-- If you want to use both, you need to call setup inside config yourself, passing the options.
-- Lazy passes opts as the second argument of config, so you can then just call require(‘myplugin’).setup(opts).

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.system({
    "git",
    "clone",
    "--filter=blob:none",
    "--single-branch",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  }, { text = true }):wait()
end
vim.opt.runtimepath:prepend(lazypath)

--Plugin list
require("lazy").setup({
  -- color theme
  require("plugins.everforest"),
  {
    "folke/tokyonight.nvim",
    opts = {
      transparent = true,
      styles = {
        sidebars = "transparent",
        floats = "transparent",
      },
    },
  },

  -- Common Plugin(Lua)
  'nvim-lua/plenary.nvim',

  -- Statusline
  { 'nvim-lualine/lualine.nvim' },

  -- WhichKey
  require("plugins.whichkey"),

  -- Buffer Control
  {
    'romgrk/barbar.nvim',
    dependencies = { 'nvim-web-devicons' }
  },
  { 'lambdalisue/glyph-palette.vim' },

  -- file explorer
  require("plugins.neo-tree"),

  --Syntax Highlight
  {
    'nvim-treesitter/nvim-treesitter',
    build = ":TSUpdate",
    ensure_installed = 'all',
  },
  { 'JoosepAlviste/nvim-ts-context-commentstring' }, -- context-comment with treesitter
  {
    "yioneko/nvim-yati",
    version = "*"
  },

  -- Telescope
  require("plugins.telescope"),

  -- LSP
  { "williamboman/mason.nvim" },
  { "williamboman/mason-lspconfig.nvim" },
  {
    "williamboman/mason.nvim",
    build = ":MasonUpdate",
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
      "neovim/nvim-lspconfig",
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      require("plugins.lsp.config").setup()
    end,
  },

  -- saga
  require("plugins.lspsaga"),

  -- auto completion
  require("plugins.nvim-cmp"),

  -- Coding Support
  { 'windwp/nvim-autopairs' },
  { 'haya14busa/vim-asterisk' },
  { 'numToStr/Comment.nvim' },
  { 'norcalli/nvim-colorizer.lua' },
  { "kylechui/nvim-surround" },
  { 'simeji/winresizer' },
  { 'prettier/vim-prettier' },
  { 'tpope/vim-fugitive' },
  { 'lewis6991/gitsigns.nvim' },
  require("plugins.markdown-preview"),

  -- terminal Integration
  { 'akinsho/toggleterm.nvim' },
  {
    'phaazon/hop.nvim',
    branch = 'v2', -- optional but strongly recommended
  },

  -- dashboard
  require("plugins.dashboard"),
})
