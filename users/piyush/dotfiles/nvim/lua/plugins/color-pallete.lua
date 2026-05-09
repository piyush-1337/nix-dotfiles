return {
  -- Interactive color picker
  {
    'uga-rosa/ccc.nvim',
    config = function()
      -- Basic setup with default pickers
      require('ccc').setup {
        -- No need to manually require pickers in newer versions
        -- The plugin handles this automatically
        output_mode = 'preserve',
      }

      -- Keymap to open color picker
      vim.keymap.set('n', '<leader>cp', '<cmd>CccPick<cr>', { desc = 'Color Picker' })
    end,
  },
}
