return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = true,
    config = function()
      local mocha = require("catppuccin.palettes").get_palette("mocha")

      require("catppuccin").setup({
        flavour = "mocha",
        transparent_background = true,
        float = {
          transparent = true,
          solid = false,
        },
        term_colors = true,
        dim_inactive = {
          enabled = false,
          shade = "dark",
          percentage = 0.1,
        },
        styles = {
          comments = { "italic" },
          conditionals = { "italic" },
          keywords = { "italic" },
          functions = { "bold" },
          strings = { "italic" },
          variables = { "bold" },
          numbers = {},
          booleans = { "bold" },
          types = { "bold" },
          operators = {},
        },
        lsp_styles = {
          virtual_text = {
            errors = { "italic" },
            hints = { "italic" },
            warnings = { "italic" },
            information = { "italic" },
            ok = { "italic" },
          },
          underlines = {
            errors = { "undercurl" },
            hints = { "undercurl" },
            warnings = { "undercurl" },
            information = { "undercurl" },
            ok = { "undercurl" },
          },
          inlay_hints = {
            background = false,
          },
        },
        custom_highlights = function(colors)
          return {
            -- flash
            FlashLabel = { fg = colors.base, bg = colors.peach, bold = true },
            FlashMatch = { fg = colors.lavender, bg = colors.surface0 },
            FlashCurrent = { fg = colors.text, bg = colors.surface1 },
            FlashBackdrop = { fg = colors.overlay0 },

            -- snacks picker
            SnacksPickerInputCursorLine = { bg = colors.surface0 },

            -- neo-tree
            NeoTreeTitleBar = { bg = colors.surface0, fg = colors.lavender, bold = true },

            -- folds
            Folded = { bg = colors.surface0, fg = colors.overlay1, italic = true },

            -- render-markdown
            RenderMarkdownCode = { bg = colors.mantle },

            -- floating windows
            NormalFloat = { bg = "NONE" },
            FloatBorder = { fg = colors.surface1, bg = "NONE" },

            -- telescope
            TelescopeBorder = { fg = colors.surface1, bg = "NONE" },
            TelescopeTitle = { fg = colors.lavender, bold = true },

            -- toggleterm
            ToogleTermNormal = { bg = "NONE" },
            ToogleTermNormalFloat = { bg = "NONE" },
            ToggleTermFloatBorder = { fg = colors.surface1, bg = "NONE" },

            -- cursor line
            CursorLine = { bg = colors.surface0 },
            CursorLineNr = { fg = colors.lavender, bold = true },

            -- selection
            Visual = { bg = colors.surface1 },

            -- winbar / incline
            WinBar = { bg = "NONE" },
            WinBarNC = { bg = "NONE" },

            -- line numbers
            LineNr = { fg = colors.surface1 },
            LineNrAbove = { fg = colors.surface1 },
            LineNrBelow = { fg = colors.surface1 },

            -- indent guides
            IblIndent = { fg = colors.surface0 },
            IblScope = { fg = colors.surface2 },
          }
        end,
        default_integrations = true,
        integrations = {
          blink_cmp = true,
          cmp = true,
          dashboard = true,
          flash = true,
          gitsigns = { enabled = true, transparent = true },
          illuminate = { enabled = true, lsp = true },
          indent_blankline = { enabled = true, scope_color = "lavender", colored_indent_levels = false },
          lsp_trouble = true,
          mason = true,
          mini = { enabled = true, indentscope_color = "lavender" },
          native_lsp = {
            enabled = true,
            virtual_text = {
              errors = { "italic" },
              hints = { "italic" },
              warnings = { "italic" },
              information = { "italic" },
              ok = { "italic" },
            },
            underlines = {
              errors = { "undercurl" },
              hints = { "undercurl" },
              warnings = { "undercurl" },
              information = { "undercurl" },
              ok = { "undercurl" },
            },
            inlay_hints = { background = true },
          },
          neotree = true,
          noice = true,
          notify = true,
          rainbow_delimiters = true,
          render_markdown = true,
          snacks = { enabled = true, indent_scope_color = "lavender" },
          telescope = { enabled = true },
          treesitter = true,
          treesitter_context = true,
          ufo = true,
          which_key = true,
        },
      })

    end,
  },
}
