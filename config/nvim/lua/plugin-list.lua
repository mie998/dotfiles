vim.cmd("autocmd!")

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
    {
        "neanias/everforest-nvim",
        version = false,
        lazy = false,
        priority = 1000, -- make sure to load this before all the other start plugins
    },
    -- Common Plugin(Lua)
    'nvim-lua/plenary.nvim',
    {'nvim-tree/nvim-web-devicons',lazy = false,priority = 1000},
    -- Statusline
    {'nvim-lualine/lualine.nvim'},
    -- Buffer Control
    {'romgrk/barbar.nvim',dependencies = { 'nvim-web-devicons' }},
    {
        'lambdalisue/fern.vim',
        dependencies = {
            { 'lambdalisue/nerdfont.vim', },
            {
                'lambdalisue/fern-renderer-nerdfont.vim',
                config = function()
                    vim.g['fern#renderer'] = "nerdfont"
                end
            },
        },
    },
    {'lambdalisue/glyph-palette.vim'},
    {'TheLeoP/fern-renderer-web-devicons.nvim',dependencies = {'nvim-web-devicons'}}, 

    --Syntax Highlight
    {'nvim-treesitter/nvim-treesitter', build = ':TSUpdate'},
    {'JoosepAlviste/nvim-ts-context-commentstring'}, -- context-comment with treesitter
    {"yioneko/nvim-yati", version="*"},

    -- Telescope
    {'nvim-telescope/telescope.nvim' },
    {'fannheyward/telescope-coc.nvim'},
    {
        "nvim-telescope/telescope-frecency.nvim",
    },

    -- Coding Support
    {'windwp/nvim-autopairs'},
    {'windwp/nvim-ts-autotag'},
    {'haya14busa/vim-asterisk'},
    {'numToStr/Comment.nvim' },
    {'norcalli/nvim-colorizer.lua' },
    {"kylechui/nvim-surround"},
    {'simeji/winresizer' },
    {
        "iamcco/markdown-preview.nvim",
        cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
        ft = { "markdown" },
        build = function() vim.fn["mkdp#util#install"]() end,
    },
    {'prettier/vim-prettier'},
    {'tpope/vim-fugitive'},
    {'lewis6991/gitsigns.nvim'},
    -- terminal Integration
    { 'akinsho/toggleterm.nvim'},
    {
        'phaazon/hop.nvim',
        branch = 'v2', -- optional but strongly recommended
    }
})
