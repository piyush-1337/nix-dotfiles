require('which-key').setup {}
require('nvim-autopairs').setup {}
require('todo-comments').setup { signs = false }

require('neodev').setup {}
require('crates').setup {
  lsp = {
    enabled = true,
    actions = true,
    completion = true,
    hover = true,
  },
  completion = {
    cmp = {
      enabled = true,
    },
  },
}

require('mini.icons').setup()

MiniIcons.mock_nvim_web_devicons()
