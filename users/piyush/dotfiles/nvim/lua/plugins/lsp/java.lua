return {
  vim.lsp.config('jdtls', {
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
  }),
  vim.lsp.enable 'jdtls',
}
