return { -- LSP Configuration & Plugins
  'neovim/nvim-lspconfig',
  dependencies = {
    -- Useful status updates for LSP.
    -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
    {
      'j-hui/fidget.nvim',
      tag = 'v1.4.0',
      opts = {
        progress = {
          display = {
            done_icon = '✓', -- Icon shown when all LSP progress tasks are complete
          },
        },
        notification = {
          window = {
            winblend = 0, -- Background color opacity in the notification window
          },
        },
      },
    },
  },
  config = function()
    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
      callback = function(event)
        local map = function(keys, func, desc)
          vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
        end

        map('<leader>sh', vim.lsp.buf.signature_help, 'Signature Help')
        map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
        map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
        map('K', vim.lsp.buf.hover, 'Hover Documentation')

        -- Highlight references on CursorHold
        local client = vim.lsp.get_client_by_id(event.data.client_id)
        if client and client.server_capabilities.documentHighlightProvider then
          vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
            buffer = event.buf,
            callback = vim.lsp.buf.document_highlight,
          })

          vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
            buffer = event.buf,
            callback = vim.lsp.buf.clear_references,
          })
        end
      end,
    })

    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())
    
    -- Your LSP server settings
    local servers = {
      nixd = {
        settings = {
          nixd = {
            formatting = { command = { "nixfmt" } },
          },
        },
      },
      lua_ls = {
        settings = {
          hint = { enable = true, setType = false, paramType = true, paramName = 'Disable', semicolon = 'Disable', arrayIndex = 'Disable' },
          Lua = {
            runtime = { version = 'LuaJIT' },
            workspace = {
              checkThirdParty = false,
              library = { '${3rd}/luv/library', unpack(vim.api.nvim_get_runtime_file('', true)) },
            },
            completion = { callSnippet = 'Replace' },
            telemetry = { enable = false },
            diagnostics = { disable = { 'missing-fields' }, globals = { 'vim' } },
          },
        },
      },
      basedpyright = {
        settings = {
          basedpyright = {
            disableOrganizeImports = true,
            disableLanguageServices = false,
            analysis = {
              typeCheckingMode = 'basic',
              useLibraryCodeForTypes = true,
              autoImportCompletions = true,
            },
          },
        },
      },
      ruff = {},
      jsonls = {},
      sqlls = {},
      bashls = {},
      tailwindcss = {},
      html = { filetypes = { 'html', 'twig', 'hbs' } },
      cssls = {},
      vtsls = {
        settings = {
          typescript = {
            tsserver = { experimental = { enableProjectDiagnostics = true } },
            format = { enable = false },
            inlayHints = {
              parameterNames = { enabled = 'all' },
              parameterTypes = { enabled = true },
              variableTypes = { enabled = true },
              propertyDeclarationTypes = { enabled = true },
              functionLikeReturnTypes = { enabled = true },
              enumMemberValues = { enabled = true },
            },
          },
          javascript = {
            tsserver = { experimental = { enableProjectDiagnostics = true } },
            format = { enable = false },
            inlayHints = {
              parameterNames = { enabled = 'all' },
              parameterTypes = { enabled = true },
              variableTypes = { enabled = true },
              propertyDeclarationTypes = { enabled = true },
              functionLikeReturnTypes = { enabled = true },
              enumMemberValues = { enabled = true },
            },
          },
          completions = { completeFunctionCalls = true },
        },
        on_attach = function(client, bufnr)
          client.server_capabilities.documentFormattingProvider = false
          client.server_capabilities.documentRangeFormattingProvider = false
          vim.lsp.inlay_hint.enable(false, { bufnr = bufnr })
        end,
      },
      emmet_language_server = {
        filetypes = { 'html', 'css', 'scss', 'javascript', 'javascriptreact', 'typescript', 'typescriptreact', 'svelte', 'vue' },
      },
      clangd = {
        cmd = { 'clangd', '--background-index', '--clang-tidy', '--header-insertion=iwyu', '--completion-style=detailed', '--function-arg-placeholders', '--malloc-trim' },
        filetypes = { 'c', 'cpp', 'objc', 'objcpp' },
        root_markers = { 'compile_commands.json', '.git' },
        init_options = { clangdFileStatus = true, usePlaceholders = true, completeUnimported = true },
      },
      svls = {
        settings = { systemverilog = {} },
        filetypes = { 'verilog', 'systemverilog' },
      },
      marksman = {},
      prismals = {},
      jdtls = {
        settings = {
          java = {
            inlayHints = { parameterNames = { enabled = 'all' }, other = { enabled = true, typeHints = true, typeHintsOptions = { showCompactTypeNames = false } } },
            configuration = { updateBuildConfiguration = 'interactive' },
            completion = { favoriteStaticMembers = { 'org.hamcrest.MatcherAssert.assertThat', 'org.hamcrest.Matchers.*', 'org.hamcrest.CoreMatchers.*', 'org.junit.jupiter.api.Assertions.*', 'java.util.Objects.requireNonNull', 'java.util.Objects.requireNonNullElse', 'org.mockito.Mockito.*' } },
            contentProvider = { preferred = 'fernflower' },
            sources = { organizeImports = { starThreshold = 9999, staticStarThreshold = 9999 } },
            codeGeneration = { toString = { template = '${object.className}{${member.name()}=${member.value}, ${otherMembers}}' }, hashCodeEquals = { useJava7Objects = true }, useBlocks = true },
          },
        },
      },
    }

    for server, cfg in pairs(servers) do
      cfg.capabilities = vim.tbl_deep_extend('force', {}, capabilities, cfg.capabilities or {})
      vim.lsp.config(server, cfg)
      vim.lsp.enable(server)
    end
  end,
}
