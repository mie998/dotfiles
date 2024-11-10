local function setup_diagnostics()
  vim.opt.updatetime = 250

  vim.diagnostic.config({
    virtual_text = false,
    float = {
      border = "rounded", -- 境界線のスタイル
      source = "always",  -- ソース（LSP名）を表示
      header = "",        -- ヘッダーテキスト
      prefix = "",        -- プレフィックステキスト
    },
  })

  vim.api.nvim_create_autocmd("CursorHold", {
    callback = function()
      local opts = {
        focusable = false,
        close_events = {
          "BufLeave",
          "CursorMoved",
          "InsertEnter",
          "FocusLost"
        },
        border = "rounded", -- 境界線のスタイル
        source = "always",  -- ソース（LSP名）を表示
        prefix = "",        -- プレフィックステキスト
        scope = "cursor",   -- カーソル位置のみの診断を表示
      }
      vim.diagnostic.open_float(nil, opts)
    end
  })
end

local M = {}

function M.setup()
  require("mason").setup({
    ui = {
      icons = {
        package_installed = "✓",
        package_pending = "➜",
        package_uninstalled = "✗"
      }
    }
  })

  require("mason-lspconfig").setup({
    ensure_installed = {
      "lua_ls",
      "pyright",
      "tsserver",
      "rust_analyzer",
    },
    automatic_installation = false,
  })

  local lspconfig = require("lspconfig")

  setup_diagnostics()

  local opts = {
    on_attach = function(client, bufnr)
      local bufopts = { noremap = true, silent = true, buffer = bufnr }

      vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
      vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)

      vim.keymap.set('n', '<C-k>', vim.lsp.buf.hover, bufopts)
      vim.keymap.set('n', '<C-k>', function()
        vim.diagnostic.open_float({ border = "rounded" })
      end, bufopts)
    end,
    capabilities = require('cmp_nvim_lsp').default_capabilities()
  }

  require("mason-lspconfig").setup_handlers({
    -- Default configuration
    function(server_name)
      lspconfig[server_name].setup(opts)
    end,

    -- Server specific configuration
    ["lua_ls"] = function()
      lspconfig.lua_ls.setup(vim.tbl_extend("force", opts, {
        settings = {
          Lua = {
            diagnostics = {
              globals = { "vim" }
            },
            workspace = {
              library = vim.api.nvim_get_runtime_file("", true),
              checkThirdParty = false,
            }
          }
        }
      }))
    end,

    ["rust_analyzer"] = function()
      lspconfig.rust_analyzer.setup(vim.tbl_extend("force", opts, {
        settings = {
          ["rust-analyzer"] = {
            checkOnSave = {
              command = "clippy"
            }
          }
        }
      }))
    end,
  })
end

return M
