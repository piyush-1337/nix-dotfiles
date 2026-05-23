-- Format on save and linters
do
  local null_ls = require 'null-ls'
  local formatting = null_ls.builtins.formatting   -- to setup formatters
  local diagnostics = null_ls.builtins.diagnostics -- to setup linters

  -- list of formatters & linters for mason to install
  require('mason-null-ls').setup {
    ensure_installed = {
      'checkmake',
      'prettier', -- ts/js formatter
      'eslint_d', -- ts/js linter
      'shfmt',
      -- 'ruff',
    },
    -- auto-install configured formatters & linters (with null-ls)
    automatic_installation = true,
  }

  local sources = {
    diagnostics.checkmake,
    formatting.prettier.with {
      filetypes = {
        'html',
        'json',
        'yaml',
        -- 'markdown',
        'javascript',
        'typescript',
        'javascriptreact',
        'typescriptreact',
        'go',
      },
    },
    formatting.shfmt.with { args = { '-i', '4' } },
    formatting.terraform_fmt,
  }

  local function format_lua_with_stylua(bufnr)
    if vim.bo[bufnr].filetype ~= 'lua' then
      return
    end

    local filename = vim.api.nvim_buf_get_name(bufnr)
    if filename == '' or vim.fn.executable 'stylua' ~= 1 then
      return
    end

    local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
    local input = table.concat(lines, '\n')
    if #lines > 0 then
      input = input .. '\n'
    end

    local result = vim
        .system({ 'stylua', '--stdin-filepath', filename, '-' }, {
          stdin = input,
          text = true,
        })
        :wait()

    if result.code ~= 0 or not result.stdout or result.stdout == '' then
      return
    end

    local output = vim.split(result.stdout, '\n', { plain = true })
    if #output > 0 and output[#output] == '' then
      table.remove(output)
    end

    if vim.deep_equal(lines, output) then
      return
    end

    vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, output)
  end

  local augroup = vim.api.nvim_create_augroup('LspFormatting', {})
  null_ls.setup {
    -- debug = true, -- Enable debug mode. Inspect logs with :NullLsLog.
    sources = sources,
    -- you can reuse a shared lspconfig on_attach callback here
    on_attach = function(client, bufnr)
      if vim.bo[bufnr].filetype == 'lua' then
        vim.api.nvim_clear_autocmds { group = augroup, buffer = bufnr }
        vim.api.nvim_create_autocmd('BufWritePre', {
          group = augroup,
          buffer = bufnr,
          callback = function()
            format_lua_with_stylua(bufnr)
          end,
        })
        return
      end

      if client:supports_method 'textDocument/formatting' then
        vim.api.nvim_clear_autocmds { group = augroup, buffer = bufnr }
        vim.api.nvim_create_autocmd('BufWritePre', {
          group = augroup,
          buffer = bufnr,
          callback = function()
            vim.lsp.buf.format { async = false }
          end,
        })
      end
    end,
  }
end
