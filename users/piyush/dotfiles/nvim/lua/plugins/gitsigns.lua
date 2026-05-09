-- Adds git related signs to the gutter, as well as utilities for managing changes
-- ▎

return {
  'lewis6991/gitsigns.nvim',
  opts = {
    signs = {
      add = { text = '▎', hl = 'GitSignsAdd' },
      change = { text = '▎', hl = 'GitSignsChange' },
      delete = { text = '_', hl = 'GitSignsDelete' },
      topdelete = { text = '‾', hl = 'GitSignsDelete' },
      changedelete = { text = '~', hl = 'GitSignsChange' },
    },
    signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
    numhl = false, -- Highlights the line number
    linehl = false, -- You can set this to true if you want to highlight entire lines
    word_diff = false, -- Enable word diff if you like
    watch_gitdir = {
      interval = 1000,
      follow_files = true,
    },
    attach_to_untracked = true,
    current_line_blame = true,
    update_debounce = 200,
    max_file_length = 40000,
    preview_config = {
      border = 'single',
      style = 'minimal',
      relative = 'cursor',
      row = 0,
      col = 1,
    },
    -- yadm = {
    --   enable = false,
    -- },
  },
}
