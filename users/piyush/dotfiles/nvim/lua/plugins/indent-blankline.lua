return {
  'lukas-reineke/indent-blankline.nvim',
  main = 'ibl',
  config = function()
    local ibl = require 'ibl'
    local hooks = require 'ibl.hooks'

    -- Highlight groups (same as before)
    hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
      vim.api.nvim_set_hl(0, 'IblIndent', { fg = '#3b4261' })
      vim.api.nvim_set_hl(0, 'IblScope', { fg = '#c5c5b0' })
    end)

    hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)

    -- Main setup
    ibl.setup {
      indent = {
        char = '│',
        highlight = 'IblIndent',
      },
      scope = {
        enabled = true,
        show_start = false,
        show_end = false,
        highlight = { 'IblScope' },
      },
      exclude = {
        filetypes = {
          'help',
          'startify',
          'dashboard',
          'packer',
          'neogitstatus',
          'NvimTree',
          'Trouble',
        },
      },
    }
  end,
}
