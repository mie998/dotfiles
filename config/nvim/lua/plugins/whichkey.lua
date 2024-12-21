-- Installation with Lazy
return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts_extend = { "spec", "disable.ft", "disable.bt" },
  opts = {
    icons = {
      group = vim.g.icons_enabled ~= false and "" or "+",
      rules = false,
      separator = "-",
    },
    mappings = {
      ["<leader>f"] = {
        name = "File",
        f = { "<cmd>Telescope find_files<cr>", "Find File" },
        r = { "<cmd>Telescope oldfiles<cr>", "Recent Files" },
        n = { "<cmd>enew<cr>", "New File" },
        s = { "<cmd>w<cr>", "Save File" },
      },
      ["<leader>l"] = {
        name = "LSP",
        f = { "<cmd>lua vim.lsp.buf.format()<cr>", "Format" },
        r = { "<cmd>lua vim.lsp.buf.rename()<cr>", "Rename" },
        a = { "<cmd>lua vim.lsp.buf.code_action()<cr>", "Code Action" },
      },
    },
  },
  keys = {
    {
      "<leader>?",
      function()
        require("which-key").show({ global = true })
      end,
      desc = "Buffer Local Keymaps (which-key)"
    },
  },
  init = function()
    vim.o.timeout = true
    vim.o.timeoutlen = 300
  end,
  dependencies = {
    { 'nvim-tree/nvim-web-devicons' }
  },
}
