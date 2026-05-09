return {
  'catppuccin/nvim',
  name = 'catppuccin',
  priority = 1000, -- Load before all other plugins
  config = function()
    require('catppuccin').setup {
      transparent_background = true,
      flavour = 'mocha', -- Options: latte, frappe, macchiato, mocha
      float = {
        transparent = true,
        solid = true,
      },
      integrations = {
        cmp = true,
        gitsigns = true,
        nvimtree = true,
        neotree = true,
        treesitter = true,
        telescope = false,
        mason = true,
        native_lsp = {
          enabled = true,
          underlines = {
            errors = { 'undercurl' },
            hints = { 'undercurl' },
            warnings = { 'undercurl' },
            information = { 'undercurl' },
          },
        },
      },
    }
    vim.cmd.colorscheme 'catppuccin-mocha'
  end,
}
