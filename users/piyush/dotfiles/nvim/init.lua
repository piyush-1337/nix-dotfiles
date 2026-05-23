require 'core.options' -- Load general options
require 'core.keymaps' -- Load general keymaps
require 'core.snippets' -- Custom code snippets
require 'core.floaterminal' -- Floaterminal setup

require('vim._core.ui2').enable()

-- Install package manager
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

-- Setup plugins
require('lazy').setup({
  require 'plugins.themes.catppuccin',
  require 'plugins.treesitter',
  require 'plugins.misc',
  require 'plugins.lsp.lsp',
  require 'plugins.autocompletion',
  require 'plugins.none-ls',
  require 'plugins.lualine',
  require 'plugins.bufferline',
  require 'plugins.debug',
  require 'plugins.gitsigns',
  require 'plugins.database',
  require 'plugins.aerial',
  require 'plugins.vim-tmux-navigator',
  require 'plugins.color-pallete',
  require 'plugins.colorizer',
  require 'plugins.lsp.flutter',
  require 'plugins.competitest',
  require 'plugins.markdown',
  require 'plugins.snacks',
  require 'plugins.lsp.rust',
  require 'plugins.lsp-signature',
  require 'plugins.gitdiff',
}, {
  ui = {
    -- If you have a Nerd Font, set icons to an empty table which will use the
    -- default lazy.nvim defined Nerd Font icons otherwise define a unicode icons table
    icons = vim.g.have_nerd_font and {} or {
      cmd = '⌘',
      config = '🛠',
      event = '📅',
      ft = '📂',
      init = '⚙',
      keys = '🗝',
      plugin = '🔌',
      runtime = '💻',
      require = '🌙',
      source = '📄',
      start = '🚀',
      task = '📌',
      lazy = '💤 ',
    },
  },
})

-- Function to check if a file exists
local function file_exists(file)
  local f = io.open(file, 'r')
  if f then
    f:close()
    return true
  else
    return false
  end
end

-- Path to the session file
local session_file = '.session.vim'

-- Check if the session file exists in the current directory
if file_exists(session_file) then
  -- Source the session file
  vim.cmd('source ' .. session_file)
end

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
