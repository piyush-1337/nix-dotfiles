return {
  'xeluxee/competitest.nvim',
  dependencies = 'MunifTanjim/nui.nvim',
  config = function()
    require('competitest').setup {
      testcases_use_single_file = false,
      testcases_directory = '.test',
    }
  end,

  vim.api.nvim_set_keymap('n', '<leader>ta', ':CompetiTest add_testcase<CR>', { noremap = true, silent = true, desc = 'Add Testcase' }),
  vim.api.nvim_set_keymap('n', '<leader>te', ':CompetiTest edit_testcase<CR>', { noremap = true, silent = true, desc = 'Edit Testcase' }),
  vim.api.nvim_set_keymap('n', '<leader>tr', ':CompetiTest run<CR>', { noremap = true, silent = true, desc = 'Run Testcases' }),
  vim.api.nvim_set_keymap('n', '<leader>rt', ':CompetiTest receive testcases<CR>', { noremap = true, silent = true, desc = 'Recieve Testcases' }),
}
