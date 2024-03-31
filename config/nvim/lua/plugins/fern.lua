return {
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
}
