return {
  'zbirenbaum/copilot.lua',
  cmd = 'Copilot',
  event = 'InsertEnter',
  build = ':Copilot auth',
  opts = {
    suggestion = {
      enabled = true,
      auto_trigger = true,
      debounce = 75,
      keymap = {
        accept = '<C-g>',
        accept_word = '<C-f>',
        next = '<C-]>',
        prev = '<C-[>',
        dismiss = '<C-d>',
      },
    },
    panel = {
      enabled = true,
      auto_refresh = false,
      keymap = {
        open = '<M-CR>',
        accept = '<CR>',
        refresh = 'gr',
        next = 'J',
        prev = 'K',
      },
    },
    filetypes = {
      yaml = true,
      markdown = true,
      help = false,
      gitcommit = true,
      gitrebase = false,
      ['.'] = false,
    },
  },
  config = function(_, opts)
    require('copilot').setup(opts)
    -- toggle Copilot suggestion
    vim.keymap.set('n', '<leader>ct', function()
      require('copilot.suggestion').toggle_auto_trigger()
      print 'Copilot toggled'
    end, { desc = 'Toggle Copilot suggestion' })
  end,
}
