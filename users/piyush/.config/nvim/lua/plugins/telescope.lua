local function get_project_root()
  -- 1. First try all active LSP clients (including those not attached to current buffer)
  for _, client in ipairs(vim.lsp.get_clients()) do
    if client.config and client.config.root_dir then
      local root = client.config.root_dir
      if root and root ~= '' and vim.fn.isdirectory(root) == 1 then
        return root
      end
    end
  end

  -- 2. Check for common project markers in parent directories
  local markers = {
    '.git',
    'package.json', -- Node.js
    'pyproject.toml', -- Python
    'go.mod', -- Go
    'Cargo.toml', -- Rust
    'Makefile',
    'build.gradle', -- Java
    'pom.xml', -- Java
    'requirements.txt', -- Python
  }

  local current_file = vim.api.nvim_buf_get_name(0)
  local current_dir = current_file ~= '' and vim.fn.fnamemodify(current_file, ':h') or vim.fn.getcwd()

  for _, marker in ipairs(markers) do
    local found = vim.fn.findfile(marker, current_dir .. ';')
    if found ~= '' then
      return vim.fn.fnamemodify(found, ':p:h')
    end
  end

  -- 3. Fallback to git root if exists
  local git_root = vim.fn.systemlist('git rev-parse --show-toplevel')[1]
  if not vim.v.shell_error and git_root ~= '' then
    return git_root
  end

  -- 4. Ultimate fallback to current working directory
  return vim.fn.getcwd()
end

-- Fuzzy Finder (files, lsp, etc)
return {
  'nvim-telescope/telescope.nvim',
  branch = '0.1.x',
  -- branch = 'master',
  dependencies = {
    'nvim-lua/plenary.nvim',
    -- Fuzzy Finder Algorithm which requires local dependencies to be built.
    -- Only load if `make` is available. Make sure you have the system
    -- requirements installed.
    {
      'nvim-telescope/telescope-fzf-native.nvim',
      build = 'make',
      cond = function()
        return vim.fn.executable 'make' == 1
      end,
    },
    'nvim-telescope/telescope-ui-select.nvim',

    -- Useful for getting pretty icons, but requires a Nerd Font.
    { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
  },

  config = function()
    local telescope = require 'telescope'
    local actions = require 'telescope.actions'
    local builtin = require 'telescope.builtin'

    require('telescope').setup {
      defaults = {
        mappings = {
          i = {
            ['<C-k>'] = actions.move_selection_previous, -- move to prev result
            ['<C-j>'] = actions.move_selection_next, -- move to next result
            ['<C-l>'] = actions.select_default, -- open file
          },
          n = {
            ['q'] = actions.close,
          },
        },
      },
      pickers = {
        find_files = {
          file_ignore_patterns = { 'node_modules', '.git', '.venv' },
          hidden = true,
        },
        buffers = {
          initial_mode = 'normal',
          sort_lastused = true,
          -- sort_mru = true,
          mappings = {
            n = {
              ['d'] = actions.delete_buffer,
              ['l'] = actions.select_default,
            },
          },
        },
      },
      live_grep = {
        file_ignore_patterns = { 'node_modules', '.git', '.venv' },
        additional_args = function(_)
          return { '--hidden' }
        end,
      },
      path_display = {
        filename_first = {
          reverse_directories = true,
        },
      },
      extensions = {
        ['ui-select'] = {
          require('telescope.themes').get_dropdown(),
        },
      },
      git_files = {
        previewer = false,
      },
    }

    -- Enable telescope fzf native, if installed
    pcall(require('telescope').load_extension, 'fzf')
    pcall(require('telescope').load_extension, 'ui-select')

    vim.keymap.set('n', '<leader>?', builtin.oldfiles, { desc = '[?] Find recently opened files' })
    vim.keymap.set('n', '<leader>sb', builtin.buffers, { desc = '[S]earch existing [B]uffers' })
    vim.keymap.set('n', '<leader>sm', builtin.marks, { desc = '[S]earch [M]arks' })
    vim.keymap.set('n', '<leader>gf', function()
      builtin.git_files {
        cwd = get_project_root(),
        show_untracked = true,
      }
    end, { desc = 'Search [G]it [F]iles in Project Root' })
    vim.keymap.set('n', '<leader>gc', function()
      builtin.git_commits {
        cwd = get_project_root(),
      }
    end, { desc = 'Search [G]it [C]ommits in Project Root' })
    vim.keymap.set('n', '<leader>gcf', function()
      builtin.git_bcommits {
        cwd = get_project_root(),
      }
    end, { desc = 'Search [G]it [C]ommits for current [F]ile in Project Root' })
    vim.keymap.set('n', '<leader>gb', function()
      builtin.git_branches {
        cwd = get_project_root(),
      }
    end, { desc = 'Search [G]it [B]ranches in Project Root' })
    vim.keymap.set('n', '<leader>gs', function()
      builtin.git_status {
        cwd = get_project_root(),
      }
    end, { desc = 'Search [G]it [S]tatus (diff view) in Project Root' })
    vim.keymap.set('n', '<leader>sf', function()
      builtin.find_files {
        cwd = get_project_root(),
        hidden = true,
        file_ignore_patterns = { 'node_modules', '.git', '.venv' },
      }
    end, { desc = '[S]earch [F]iles in Project Root' })
    vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
    vim.keymap.set('n', '<leader>sw', function()
      builtin.grep_string {
        cwd = get_project_root(),
      }
    end, { desc = '[S]earch current [W]ord in Project Root' })
    vim.keymap.set('n', '<leader>sg', function()
      builtin.live_grep {
        cwd = get_project_root(),
        file_ignore_patterns = { 'node_modules', '.git', '.venv' },
        additional_args = function(_)
          return { '--hidden' }
        end,
      }
    end, { desc = '[S]earch by [G]rep in Project Root' })
    vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
    vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]resume' })
    vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
    vim.keymap.set('n', '<leader>sds', function()
      builtin.lsp_document_symbols {
        symbols = { 'Class', 'Function', 'Method', 'Constructor', 'Interface', 'Module', 'Property' },
      }
    end, { desc = '[S]each LSP document [S]ymbols' })

    vim.keymap.set('n', '<leader><leader>', function()
      require('telescope.builtin').find_files {
        cwd = get_project_root(),
        hidden = true,
        file_ignore_patterns = { 'node_modules', '.git', '.venv' },
      }
    end, { desc = 'Search Files in Project Root' })

    vim.keymap.set('n', '<leader>s/', function()
      builtin.live_grep {
        grep_open_files = true,
        prompt_title = 'Live Grep in Open Files',
      }
    end, { desc = '[S]earch [/] in Open Files' })
    vim.keymap.set('n', '<leader>/', function()
      -- You can pass additional configuration to telescope to change theme, layout, etc.
      builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
        previewer = false,
      })
    end, { desc = '[/] Fuzzily search in current buffer' })
  end,
}
