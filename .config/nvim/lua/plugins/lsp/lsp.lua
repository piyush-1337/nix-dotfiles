return { -- LSP Configuration & Plugins
  'neovim/nvim-lspconfig',
  dependencies = {
    -- Automatically install LSPs and related tools to stdpath for neovim
    'williamboman/mason.nvim',
    'williamboman/mason-lspconfig.nvim',
    'WhoIsSethDaniel/mason-tool-installer.nvim',

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
      -- Create a function that lets us more easily define mappings specific LSP related items.
      -- It sets the mode, buffer and description for us each time.
      callback = function(event)
        local map = function(keys, func, desc)
          vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
        end

        map('<leader>sh', vim.lsp.buf.signature_help, 'Signature Help')
        --
        -- -- Jump to the definition of the word under your cursor.
        -- --  This is where a variable was first declared, or where a function is defined, etc.
        -- --  To jump back, press <C-T>.
        -- map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
        --
        -- -- Find references for the word under your cursor.
        -- map('<leader>gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
        --
        -- -- Jump to the implementation of the word under your cursor.
        -- --  Useful when your language has ways of declaring types without an actual implementation.
        -- map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
        --
        -- -- Jump to the type of the word under your cursor.
        -- --  Useful when you're not sure what type a variable is and you want to see
        -- --  the definition of its *type*, not where it was *defined*.
        -- map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')
        --
        -- -- Fuzzy find all the symbols in your current document.
        -- --  Symbols are things like variables, functions, types, etc.
        -- map('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
        --
        -- -- Fuzzy find all the symbols in your current workspace
        -- --  Similar to document symbols, except searches over your whole project.
        -- map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
        --
        -- -- Rename the variable under your cursor
        -- --  Most Language Servers support renaming across files, etc.
        map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
        --
        -- -- Execute a code action, usually your cursor needs to be on top of an error
        -- -- or a suggestion from your LSP for this to activate.
        map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
        --
        -- -- Opens a popup that displays documentation about the word under your cursor
        -- --  See `:help K` for why this keymap
        map('K', vim.lsp.buf.hover, 'Hover Documentation')
        --
        -- -- WARN: This is not Goto Definition, this is Goto Declaration.
        -- --  For example, in C this would take you to the header
        -- map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
        --
        -- map('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
        -- map('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
        -- map('<leader>wl', function()
        --   print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        -- end, '[W]orkspace [L]ist Folders')

        -- The following two autocommands are used to highlight references of the
        -- word under your cursor when your cursor rests there for a little while.
        --    See `:help CursorHold` for information about when this is executed
        --
        -- When you move your cursor, the highlights will be cleared (the second autocommand).
        local client = vim.lsp.get_client_by_id(event.data.client_id)

        -- Add this just after getting `client`
        -- if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
        --   map('<leader>th', function()
        --     vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
        --   end, '[T]oggle Inlay [H]ints')
        -- end

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
    -- Enable the following language servers
    local servers = {
      nixd = {
        settings = {
          nixd = {
            formatting = {
              command = { "nixfmt" },
            },
          },
        },
      },
      lua_ls = {
        -- cmd = {...},
        -- filetypes { ...},
        -- capabilities = {},
        settings = {
          hint = {
            enable = true,
            setType = false,
            paramType = true,
            paramName = 'Disable',
            semicolon = 'Disable',
            arrayIndex = 'Disable',
          },
          Lua = {
            runtime = { version = 'LuaJIT' },
            workspace = {
              checkThirdParty = false,
              -- Tells lua_ls where to find all the Lua files that you have loaded
              -- for your neovim configuration.
              library = {
                '${3rd}/luv/library',
                unpack(vim.api.nvim_get_runtime_file('', true)),
              },
              -- If lua_ls is really slow on your computer, you can try this instead:
              -- library = { vim.env.VIMRUNTIME },
            },
            completion = {
              callSnippet = 'Replace',
            },
            telemetry = { enable = false },
            diagnostics = {
              disable = { 'missing-fields' },
              globals = { 'vim' },
            },
          },
        },
      },
      -- pylsp = {
      --   settings = {
      --     pylsp = {
      --       plugins = {
      --         pyflakes = { enabled = false },
      --         pycodestyle = { enabled = false },
      --         autopep8 = { enabled = false },
      --         yapf = { enabled = false },
      --         mccabe = { enabled = false },
      --         pylsp_mypy = { enabled = false },
      --         pylsp_black = { enabled = false },
      --         pylsp_isort = { enabled = false },
      --       },
      --     },
      --   },
      -- },
      basedpyright = {
        -- Config options: https://github.com/DetachHead/basedpyright/blob/main/docs/settings.md
        settings = {
          -- python = {
          --   pythonPath = get_venv_python(),
          -- },
          basedpyright = {
            disableOrganizeImports = true, -- Using Ruff's import organizer
            disableLanguageServices = false,
            analysis = {
              -- ignore = {}, -- Ignore all files for analysis to exclusively use Ruff for linting
              typeCheckingMode = 'basic',
              -- diagnosticMode = 'openFilesOnly', -- Only analyze open files
              useLibraryCodeForTypes = true,
              autoImportCompletions = true, -- whether pyright offers auto-import completions
            },
          },
        },
      },
      ruff = {},
      jsonls = {},
      sqlls = {},
      -- terraformls = {},
      -- yamlls = {},
      bashls = {},
      -- dockerls = {},
      -- docker_compose_language_service = {},
      tailwindcss = {},
      -- graphql = {},
      html = { filetypes = { 'html', 'twig', 'hbs' } },
      cssls = {},
      -- ltex = {},
      -- texlab = {},

      vtsls = {
        settings = {
          typescript = {
            tsserver = {
              experimental = {
                enableProjectDiagnostics = true,
              },
            },
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
            tsserver = {
              experimental = {
                enableProjectDiagnostics = true,
              },
            },
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
          completions = {
            completeFunctionCalls = true,
          },
        },
        on_attach = function(client, bufnr)
          client.server_capabilities.documentFormattingProvider = false
          client.server_capabilities.documentRangeFormattingProvider = false
          vim.lsp.inlay_hint.enable(false, { bufnr = bufnr })
        end,
      },
      -- rust_analyzer = {
      --   cmd = { vim.fn.stdpath 'data' .. '/mason/bin/rust-analyzer' },
      --   settings = {
      --     ['rust-analyzer'] = {
      --       cargo = {
      --         -- allFeatures = true,
      --         -- features = 'all',
      --         buildScripts = {
      --           enable = true,
      --           rebuildOnSave = true,
      --         },
      --         autoreload = true,
      --         allTargets = true,
      --       },
      --       procMacro = {
      --         enable = true,
      --       },
      --       checkOnSave = true,
      --       check = {
      --         command = 'check',
      --         enabled = true,
      --       },
      --       diagnostics = {
      --         enabled = true,
      --         refreshOnInsertMode = true,
      --       },
      --       inlayHints = {
      --         bindingModeHints = {
      --           enable = true,
      --         },
      --         chainingHints = {
      --           enable = true,
      --         },
      --         closingBraceHints = {
      --           enable = true,
      --         },
      --         closureReturnTypeHints = {
      --           enable = 'always',
      --         },
      --         lifetimeElisionHints = {
      --           enable = 'always',
      --           useParameterNames = true,
      --         },
      --       },
      --     },
      --   },
      -- },

      emmet_language_server = {
        filetypes = {
          'html',
          'css',
          'scss',
          'javascript',
          'javascriptreact',
          'typescript',
          'typescriptreact',
          'svelte',
          'vue',
        },
      },

      clangd = {
        cmd = {
          'clangd',
          '--background-index',
          '--clang-tidy',
          '--header-insertion=iwyu',
          '--completion-style=detailed',
          '--function-arg-placeholders',
          '--malloc-trim',
        },
        filetypes = { 'c', 'cpp', 'objc', 'objcpp' },
        root_markers = { 'compile_commands.json', '.git' },
        init_options = {
          clangdFileStatus = true,
          usePlaceholders = true,
          completeUnimported = true,
        },
        capabilities = require('cmp_nvim_lsp').default_capabilities(),
        settings = {},
      },
      svls = {
        settings = {
          systemverilog = {
            -- you can put extra config here if needed
            -- e.g., include directories:
            -- includeIndexing = { "src/**/*.sv", "include/**/*.svh" },
            -- defines = { "SYNTHESIS", "SIMULATION" },
          },
        },
        filetypes = { 'verilog', 'systemverilog' },
      },
      marksman = {},
      prismals = {},
      -- gopls = {
      --   settings = {
      --     gopls = {
      --       analyses = {
      --         nilness = true,
      --         unusedparams = true,
      --         unusedwrite = true,
      --         unusedvariable = true,
      --       },
      --       staticcheck = true,
      --       usePlaceholders = true,
      --       hints = {
      --         assignVariableTypes = true,
      --         compositeLiteralFields = true,
      --         compositeLiteralTypes = true,
      --         constantValues = true,
      --         functionTypeParameters = true,
      --         parameterNames = true,
      --         rangeVariableTypes = true,
      --       },
      --     },
      --   },
      -- },
      jdtls = {
        settings = {
          java = {
            inlayHints = {
              parameterNames = {
                enabled = 'all', -- or "literals" for only literal parameter names
              },
              other = {
                enabled = true,
                typeHints = true,
                typeHintsOptions = {
                  showCompactTypeNames = false,
                },
              },
            },
            configuration = {
              updateBuildConfiguration = 'interactive',
            },
            completion = {
              favoriteStaticMembers = {
                'org.hamcrest.MatcherAssert.assertThat',
                'org.hamcrest.Matchers.*',
                'org.hamcrest.CoreMatchers.*',
                'org.junit.jupiter.api.Assertions.*',
                'java.util.Objects.requireNonNull',
                'java.util.Objects.requireNonNullElse',
                'org.mockito.Mockito.*',
              },
            },
            contentProvider = { preferred = 'fernflower' },
            sources = {
              organizeImports = {
                starThreshold = 9999,
                staticStarThreshold = 9999,
              },
            },
            codeGeneration = {
              toString = {
                template = '${object.className}{${member.name()}=${member.value}, ${otherMembers}}',
              },
              hashCodeEquals = {
                useJava7Objects = true,
              },
              useBlocks = true,
            },
          },
        },
      },
      taplo = {
        settings = {
          executeCommands = true,
        },
      },
    }

    -- Ensure the servers and tools above are installed
    require('mason').setup()

    -- You can add other tools here that you want Mason to install
    -- for you, so that they are available from within Neovim.
    local ensure_installed = vim.tbl_keys(servers or {})
    
    -- Filter out servers that are not available in Mason, like nixd
    ensure_installed = vim.tbl_filter(function(name)
      return name ~= 'nixd'
    end, ensure_installed)

    require('mason-tool-installer').setup { ensure_installed = ensure_installed }

    for server, cfg in pairs(servers) do
      -- For each LSP server (cfg), we merge:
      -- 1. A fresh empty table (to avoid mutating capabilities globally)
      -- 2. Your capabilities object with Neovim + cmp features
      -- 3. Any server-specific cfg.capabilities if defined in `servers`
      cfg.capabilities = vim.tbl_deep_extend('force', {}, capabilities, cfg.capabilities or {})

      vim.lsp.config(server, cfg)
      vim.lsp.enable(server)
    end
  end,
}
