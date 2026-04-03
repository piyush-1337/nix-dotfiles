return {
  'nvim-treesitter/nvim-treesitter',
  build = ':TSUpdate',
  dependencies = {
    'nvim-treesitter/nvim-treesitter-textobjects',
  },
  config = function()
    -- Setup and Parser Installation
    require('nvim-treesitter').setup()

    local parsers = {
      'lua', 'python', 'javascript', 'typescript', 'vimdoc', 'vim', 'regex',
      'terraform', 'sql', 'dockerfile', 'toml', 'json', 'java', 'groovy',
      'go', 'gitignore', 'graphql', 'yaml', 'make', 'cmake', 'markdown',
      'markdown_inline', 'bash', 'tsx', 'css', 'html', 'rust', 'nix',
    }
    
    require('nvim-treesitter').install(parsers)

    -- Highlighting & Indent (Handled natively by Neovim)
    vim.api.nvim_create_autocmd('FileType', {
      pattern = '*',
      callback = function(args)
        -- Start syntax highlighting
        pcall(vim.treesitter.start, args.buf)
        -- Set experimental indentation
        vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end,
    })

    -- Incremental Selection
    -- Neovim 0.12+ includes incremental selection natively via `vim.treesitter._select`
    vim.keymap.set({ 'n', 'x' }, '<c-space>', function()
      if vim.fn.mode() == 'n' then
        require('vim.treesitter._select').init_selection()
      else
        require('vim.treesitter._select').select_parent()
      end
    end, { desc = 'Increment selection' })

    vim.keymap.set('x', '<M-space>', function()
      require('vim.treesitter._select').select_child()
    end, { desc = 'Decrement selection' })
    
    vim.keymap.set('x', '<c-s>', function()
      -- Maps scope to parent behavior
      require('vim.treesitter._select').select_parent() 
    end, { desc = 'Increment scope' })

    -- Textobjects
    -- Setup is now minimal; keymaps must be defined explicitly
    require("nvim-treesitter-textobjects").setup({
      select = { lookahead = true },
      move = { set_jumps = true },
    })

    -- Textobjects: Select
    local select = require("nvim-treesitter-textobjects.select")
    local modes = { "x", "o" }
    vim.keymap.set(modes, 'aa', function() select.select_textobject('@parameter.outer', 'textobjects') end)
    vim.keymap.set(modes, 'ia', function() select.select_textobject('@parameter.inner', 'textobjects') end)
    vim.keymap.set(modes, 'af', function() select.select_textobject('@function.outer', 'textobjects') end)
    vim.keymap.set(modes, 'if', function() select.select_textobject('@function.inner', 'textobjects') end)
    vim.keymap.set(modes, 'ac', function() select.select_textobject('@class.outer', 'textobjects') end)
    vim.keymap.set(modes, 'ic', function() select.select_textobject('@class.inner', 'textobjects') end)

    -- Textobjects: Move
    local move = require("nvim-treesitter-textobjects.move")
    local move_modes = { "n", "x", "o" }
    vim.keymap.set(move_modes, ']m', function() move.goto_next_start('@function.outer', 'textobjects') end)
    vim.keymap.set(move_modes, ']]', function() move.goto_next_start('@class.outer', 'textobjects') end)
    vim.keymap.set(move_modes, ']M', function() move.goto_next_end('@function.outer', 'textobjects') end)
    vim.keymap.set(move_modes, '][', function() move.goto_next_end('@class.outer', 'textobjects') end)
    vim.keymap.set(move_modes, '[m', function() move.goto_previous_start('@function.outer', 'textobjects') end)
    vim.keymap.set(move_modes, '[[', function() move.goto_previous_start('@class.outer', 'textobjects') end)
    vim.keymap.set(move_modes, '[M', function() move.goto_previous_end('@function.outer', 'textobjects') end)
    vim.keymap.set(move_modes, '[]', function() move.goto_previous_end('@class.outer', 'textobjects') end)

    -- Textobjects: Swap
    local swap = require("nvim-treesitter-textobjects.swap")
    vim.keymap.set('n', '<leader>a', function() swap.swap_next('@parameter.inner') end)
    vim.keymap.set('n', '<leader>A', function() swap.swap_previous('@parameter.inner') end)
  end,
}
