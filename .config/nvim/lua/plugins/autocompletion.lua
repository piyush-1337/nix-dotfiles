return { -- Autocompletion
  'hrsh7th/nvim-cmp',
  -- event = 'InsertEnter',
  dependencies = {
    -- Snippet Engine & its associated nvim-cmp source
    {
      'L3MON4D3/LuaSnip',
      build = (function()
        -- Build Step is needed for regex support in snippets
        -- This step is not supported in many windows environments
        -- Remove the below condition to re-enable on windows
        if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
          return
        end
        return 'make install_jsregexp'
      end)(),
    },
    'saadparwaiz1/cmp_luasnip',

    -- Adds other completion capabilities.
    --  nvim-cmp does not ship with all sources by default. They are split
    --  into multiple repos for maintenance purposes.
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-path',

    -- Adds a number of user-friendly snippets
    'rafamadriz/friendly-snippets',
  },
  config = function()
    local cmp = require 'cmp'
    require('luasnip.loaders.from_vscode').lazy_load()
    require('luasnip.loaders.from_snipmate').lazy_load()
    local luasnip = require 'luasnip'
    luasnip.config.setup {}

    local kind_icons = {
      Text = '󰉿',
      Method = 'm',
      Function = '󰊕',
      Constructor = '',
      Field = '',
      Variable = '󰆧',
      Class = '󰌗',
      Interface = '',
      Module = '',
      Property = '',
      Unit = '',
      Value = '󰎠',
      Enum = '',
      Keyword = '󰌋',
      Snippet = '',
      Color = '󰏘',
      File = '󰈙',
      Reference = '',
      Folder = '󰉋',
      EnumMember = '',
      Constant = '󰇽',
      Struct = '',
      Event = '',
      Operator = '󰆕',
      TypeParameter = '󰊄',
      Codeium = '',
    }

    cmp.setup {
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },
      completion = { completeopt = 'menu,menuone,noinsert' },
      -- window = {
      --     completion = cmp.config.window.bordered(),
      --     documentation = cmp.config.window.bordered(),
      -- },
      mapping = cmp.mapping.preset.insert {
        -- ['<C-j>'] = cmp.mapping.select_next_item(),       -- Select the [n]ext item
        -- ['<C-k>'] = cmp.mapping.select_prev_item(),       -- Select the [p]revious item
        ['<CR>'] = cmp.mapping.confirm { select = true }, -- Accept the completion with Enter.
        ['<C-c>'] = cmp.mapping.complete {}, -- Manually trigger a completion from nvim-cmp.

        -- Think of <c-l> as moving to the right of your snippet expansion.
        --  So if you have a snippet that's like:
        --  function $name($args)
        --    $body
        --  end
        --
        -- <c-l> will move you to the right of each of the expansion locations.
        -- <c-h> is similar, except moving you backwards.
        ['<C-l>'] = cmp.mapping(function()
          if luasnip.expand_or_locally_jumpable() then
            luasnip.expand_or_jump()
          end
        end, { 'i', 's' }),
        ['<C-h>'] = cmp.mapping(function()
          if luasnip.locally_jumpable(-1) then
            luasnip.jump(-1)
          end
        end, { 'i', 's' }),

        -- Select next/previous item with Tab / Shift + Tab
        ['<Tab>'] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          elseif luasnip.expand_or_locally_jumpable() then
            luasnip.expand_or_jump()
          else
            fallback()
          end
        end, { 'i', 's' }),
        ['<S-Tab>'] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif luasnip.locally_jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { 'i', 's' }),
      },
      sources = {
        { name = 'codeium' },
        { name = 'nvim_lsp', priority = 100 },
        { name = 'luasnip' },
        { name = 'buffer' },
        { name = 'path' },
        { name = 'crates' },
        { name = 'nvim_lsp_signature_help' },
      },

      sorting = {
        priority_weight = 2,
        comparators = {
          cmp.config.compare.exact,

          -- Force snippets to the bottom of the list
          function(entry1, entry2)
            local kind1 = entry1:get_kind()
            local kind2 = entry2:get_kind()
            local is_snippet1 = kind1 == cmp.lsp.CompletionItemKind.Snippet
            local is_snippet2 = kind2 == cmp.lsp.CompletionItemKind.Snippet
            
            if is_snippet1 ~= is_snippet2 then
              return not is_snippet1 -- Returns true if entry1 is NOT a snippet
            end
          end,

          cmp.config.compare.score,
          cmp.config.compare.recently_used,
          cmp.config.compare.locality,

          -- custom kind sorter (acts as a tie-breaker for remaining items)
          function(entry1, entry2)
            local kind_priority = {
              [cmp.lsp.CompletionItemKind.Field] = 100,
              [cmp.lsp.CompletionItemKind.Property] = 100,
              [cmp.lsp.CompletionItemKind.Variable] = 90,
              [cmp.lsp.CompletionItemKind.EnumMember] = 90,
              [cmp.lsp.CompletionItemKind.Method] = 70,
              [cmp.lsp.CompletionItemKind.Function] = 60,
              [cmp.lsp.CompletionItemKind.Constructor] = 50,
              [cmp.lsp.CompletionItemKind.Class] = 40,
              [cmp.lsp.CompletionItemKind.Interface] = 40,
              [cmp.lsp.CompletionItemKind.Module] = 40,
              [cmp.lsp.CompletionItemKind.Struct] = 40,
              [cmp.lsp.CompletionItemKind.Constant] = 30,
              [cmp.lsp.CompletionItemKind.Keyword] = 20,
              [cmp.lsp.CompletionItemKind.Snippet] = 10,
              [cmp.lsp.CompletionItemKind.Text] = 5,
            }

            local kind1 = kind_priority[entry1:get_kind()] or 0
            local kind2 = kind_priority[entry2:get_kind()] or 0

            if kind1 ~= kind2 then
              return kind1 > kind2
            end
          end,

          cmp.config.compare.offset,
          cmp.config.compare.order,
        },
      },
      formatting = {
        fields = { 'kind', 'abbr', 'menu' },
        format = function(entry, vim_item)
          -- Kind icons
          vim_item.kind = string.format('%s', kind_icons[vim_item.kind])
          -- vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind], vim_item.kind) -- This concatonates the icons with the name of the item kind
          vim_item.menu = ({
            nvim_lsp = '[LSP]',
            luasnip = '[Snippet]',
            buffer = '[Buffer]',
            path = '[Path]',
            codeium = '[Codeium]',
          })[entry.source.name]
          return vim_item
        end,
      },
    }
  end,
}
