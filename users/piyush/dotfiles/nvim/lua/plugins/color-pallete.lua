-- Interactive color picker
require('ccc').setup {
  -- No need to manually require pickers in newer versions
  -- The plugin handles this automatically
  output_mode = 'preserve',
}

vim.keymap.set('n', '<leader>cp', '<cmd>CccPick<cr>', { desc = 'Color Picker' })
