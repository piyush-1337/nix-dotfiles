local M = {}

local gh = function(repo)
  return 'https://github.com/' .. repo
end

function M.setup()
  vim.api.nvim_create_autocmd('PackChanged', {
    callback = function(event)
      local name = event.data.spec.name
      local kind = event.data.kind

      if name == 'LuaSnip' and (kind == 'install' or kind == 'update') and vim.fn.executable 'make' == 1 then
        vim.system({ 'make', 'install_jsregexp' }, { cwd = event.data.path })
      end

      if name == 'nvim-treesitter' and (kind == 'install' or kind == 'update') then
        vim.schedule(function()
          pcall(vim.cmd.TSUpdate)
        end)
      end
    end,
  })

  vim.pack.add({
    { src = gh 'catppuccin/nvim', name = 'catppuccin' },
    { src = gh 'rebelot/kanagawa.nvim', name = 'kanagawa' },
    { src = gh 'scottmckendry/cyberdream.nvim', name = 'cyberdream' },
    gh 'folke/snacks.nvim',

    gh 'nvim-lua/plenary.nvim',
    gh 'MunifTanjim/nui.nvim',
    gh 'nvim-tree/nvim-web-devicons',
    gh 'stevearc/dressing.nvim',
    gh 'nvim-mini/mini.nvim',

    gh 'nvim-treesitter/nvim-treesitter',
    gh 'nvim-treesitter/nvim-treesitter-textobjects',
    gh 'windwp/nvim-ts-autotag',

    gh 'neovim/nvim-lspconfig',
    { src = gh 'j-hui/fidget.nvim', version = 'v1.4.0' },
    gh 'folke/neodev.nvim',
    gh 'ray-x/lsp_signature.nvim',
    gh 'nvim-flutter/flutter-tools.nvim',
    { src = gh 'mrcjkb/rustaceanvim', version = vim.version.range '9' },

    gh 'hrsh7th/nvim-cmp',
    gh 'hrsh7th/cmp-nvim-lsp',
    gh 'hrsh7th/cmp-buffer',
    gh 'hrsh7th/cmp-path',
    gh 'saadparwaiz1/cmp_luasnip',
    gh 'L3MON4D3/LuaSnip',
    gh 'rafamadriz/friendly-snippets',

    gh 'nvimtools/none-ls.nvim',
    gh 'nvimtools/none-ls-extras.nvim',
    gh 'jayp0521/mason-null-ls.nvim',
    gh 'williamboman/mason.nvim',

    gh 'nvim-lualine/lualine.nvim',
    gh 'akinsho/bufferline.nvim',
    gh 'moll/vim-bbye',
    gh 'lewis6991/gitsigns.nvim',
    gh 'dlyongemallo/diffview.nvim',
    gh 'tpope/vim-fugitive',
    gh 'tpope/vim-rhubarb',
    gh 'christoomey/vim-tmux-navigator',

    gh 'mfussenegger/nvim-dap',
    gh 'rcarriga/nvim-dap-ui',
    gh 'nvim-neotest/nvim-nio',
    gh 'jay-babu/mason-nvim-dap.nvim',
    gh 'leoluz/nvim-dap-go',
    gh 'mfussenegger/nvim-dap-python',

    gh 'kristijanhusak/vim-dadbod',
    gh 'kristijanhusak/vim-dadbod-ui',
    gh 'kristijanhusak/vim-dadbod-completion',

    gh 'stevearc/aerial.nvim',
    gh 'uga-rosa/ccc.nvim',
    gh 'brenoprata10/nvim-highlight-colors',
    gh 'xeluxee/competitest.nvim',
    gh 'MeanderingProgrammer/render-markdown.nvim',
    { src = gh 'saecki/crates.nvim', version = 'stable' },
    gh 'folke/todo-comments.nvim',
    gh 'windwp/nvim-autopairs',
    gh 'tpope/vim-sleuth',
    gh 'folke/which-key.nvim',
  }, { confirm = false, load = true })
end

return M
