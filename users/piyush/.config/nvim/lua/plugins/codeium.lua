return {
  'Exafunction/codeium.nvim',
  config = function()
    require('codeium').setup {
      enable_cmp_source = false,
      request_timeout = 20000,
      log_level = 'off',
      virtual_text = {
        enabled = true,
        manual = false,
        idle_delay = 75,
        default_filetype_enabled = true,
        key_bindings = {
          accept = '<C-g>',
          accept_word = '<C-f>',
          next = '<M-]>',
          prev = '<M-[>',
        },
        accept_fallback = '<C-\\>',
      },
      workspace_root = {
        use_lsp = true,
        find_root = nil,
        paths = {
          '.bzr',
          '.git',
          '.hg',
          '.svn',
          '_FOSSIL_',
          'package.json',
        },
      },
    }
  end,

  vim.keymap.set('n', '<leader>cc', function()
    require('codeium').toggle()
  end, { desc = 'Codeium' }),
}
