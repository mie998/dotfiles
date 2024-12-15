local config = function()
  local cmp = require("cmp")

  cmp.setup({
    preselect = cmp.PreselectMode.Item,
    keyword_length = 2,
    snippet = {
      expand = function(args)
        require("luasnip").lsp_expand(args.body)
      end,
    },
    window = {
      completion = cmp.config.window.bordered(),
      documentation = cmp.config.window.bordered(),
    },
    view = {
      entries = {
        name = "custom",
        selection_order = "near_cursor",
        follow_cursor = true,
      },
    },
    mapping = {
      ["<CR>"] = cmp.mapping(
        cmp.mapping.confirm({
          select = true,
          behavior = cmp.ConfirmBehavior.Insert,
        })
      ),
      ["<Tab>"] = cmp.mapping(
        cmp.mapping.confirm({
          select = true,
          behavior = cmp.ConfirmBehavior.Insert,
        })
      ),
      ["<C-n>"] = cmp.mapping.select_next_item({
        behavior = cmp.ConfirmBehavior.Insert,
      }),
      ["<C-p>"] = cmp.mapping.select_prev_item({
        behavior = cmp.ConfirmBehavior.Insert,
      }),
      ["<C-b>"] = cmp.mapping.scroll_docs(-5),
      ["<C-f>"] = cmp.mapping.scroll_docs(5),
      ["<C-q>"] = cmp.mapping.abort(),
      ['<C-x>'] = cmp.mapping(function()
        if not cmp.visible() then
          cmp.complete()
        end
      end, {'i'}),
    },
    sources = cmp.config.sources({
      {
        name = "luasnip",
        group_index = 1,
        option = { use_show_condition = true },
      },
      {
        name = "nvim_lsp",
        group_index = 2,
      },
      {
        name = "nvim_lua",
        group_index = 3,
      },
      {
        name = "treesitter",
        keyword_length = 4,
        group_index = 4,
      },
      {
        name = "path",
        keyword_length = 4,
        group_index = 4,
      },
      {
        name = "buffer",
        keyword_length = 3,
        group_index = 5,
        option = {
          get_bufnrs = function()
            local bufs = {}
            for _, win in ipairs(vim.api.nvim_list_wins()) do
              bufs[vim.api.nvim_win_get_buf(win)] = true
            end
            return vim.tbl_keys(bufs)
          end,
        },
      },
      {
        name = "lazydev",
        keyword_length = 2,
        group_index = 0,
      },
    }),
    sorting = {
      priority_weight = 2,
      comparators = {
        cmp.config.compare.offset,
        cmp.config.compare.exact,
        cmp.config.compare.score,
        cmp.config.compare.recently_used,
        cmp.config.compare.kind,
        cmp.config.compare.sort_text,
        cmp.config.compare.length,
        cmp.config.compare.order,
      },
    },
    formatting = {
      format = function(entry, vim_item)
        vim_item.kind = require('lspkind').presets.default[vim_item.kind]
        vim_item.menu = ({
          buffer = "[Buffer]",
          nvim_lsp = "[LSP]",
          luasnip = "[Snippet]",
          path = "[Path]",
        })[entry.source.name]
        return vim_item
      end,
    },
  })

  -- setting for cmdline
  require('cmp').setup.cmdline(':', {
    -- NOTE: なぜか他のcmpと<C-n> と <C-p> の挙動が逆になるので修正したい
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
      { name = 'path' },
      { name = 'cmdline' }
    },
    formatting = {
      format = function(entry, vim_item)
        vim_item.kind = require('lspkind').presets.default[vim_item.kind]
        return vim_item
      end,
    },
    window = {
      completion = {
        border = 'rounded',
        winhighlight = 'Normal:Normal,FloatBorder:FloatBorder,CursorLine:Visual,Search:None',
      },
    },
  })
  require('cmp').setup.cmdline('/', {
    -- NOTE: なぜか他のcmpと <C-n> と <C-p> の挙動が逆になるので修正したい
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
      { name = 'buffer' }
    }
  })
end

return {
  "hrsh7th/nvim-cmp",
  config = config,
  event = "InsertEnter",
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    dependencies = {
      "L3MON4D3/LuaSnip",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-nvim-lua",
      "hrsh7th/cmp-cmdline",
      "ray-x/cmp-treesitter",
      "saadparwaiz1/cmp_luasnip",
      'onsails/lspkind.nvim',
      {
        "rcarriga/cmp-dap",
        dependencies = "mfussenegger/nvim-dap",
      },
    },
  },
}
