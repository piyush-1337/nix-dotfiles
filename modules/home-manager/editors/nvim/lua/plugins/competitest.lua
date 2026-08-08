require('competitest').setup {
  testcases_use_single_file = false,
  testcases_directory = '.test',

  compile_command = {
    cpp = { 
      exec = 'g++', 
      args = {
        '-std=c++23',
        '-O2',
        '-Wall',
        '-Wextra',
        '-Wconversion',
        '-DLOCAL',
        '$(FNAME)',
        '-o',
        '$(FNOEXT)'
      } 
    },
  },
  
}

vim.api.nvim_set_keymap('n', '<leader>ta', ':CompetiTest add_testcase<CR>', { noremap = true, silent = true, desc = 'Add Testcase' })
vim.api.nvim_set_keymap('n', '<leader>te', ':CompetiTest edit_testcase<CR>', { noremap = true, silent = true, desc = 'Edit Testcase' })
vim.api.nvim_set_keymap('n', '<leader>tr', ':CompetiTest run<CR>', { noremap = true, silent = true, desc = 'Run Testcases' })
vim.api.nvim_set_keymap('n', '<leader>rt', ':CompetiTest receive testcases<CR>', { noremap = true, silent = true, desc = 'Recieve Testcases' })
