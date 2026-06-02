require('aerial').setup {
  -- optionally use on_attach to set keymaps when aerial has attached to a buffer
  on_attach = function(bufnr)
    -- Jump forwards/backwards with '{' and '}'
    vim.keymap.set('n', '{', '<cmd>AerialPrev<CR>', { buffer = bufnr })
    vim.keymap.set('n', '}', '<cmd>AerialNext<CR>', { buffer = bufnr })
  end,
  layout = {
    min_width = 30,
  },
}

vim.keymap.set('n', '<leader>o', '<cmd>AerialToggle!<CR>')
vim.keymap.set('n', '<leader>on', '<cmd>AerialNavToggle<CR>')
