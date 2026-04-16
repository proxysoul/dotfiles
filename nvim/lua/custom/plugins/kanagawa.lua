return {
  'rebelot/kanagawa.nvim',
  lazy = false,
  priority = 1000,
  config = function()
    -- Default options:
    require('kanagawa').setup {
      compile = false, -- enable compiling the colorscheme
      undercurl = true, -- enable undercurls
      commentStyle = { italic = true },
      functionStyle = {},
      keywordStyle = { italic = true },
      statementStyle = { bold = true },
      typeStyle = {},
      transparent = true, -- do not set background color
      dimInactive = false, -- dim inactive window `:h hl-NormalNC`
      terminalColors = true, -- define vim.g.terminal_color_{0,17}
      colors = { -- add/modify theme and palette colors
        palette = {},
        theme = { wave = {}, lotus = {}, dragon = {}, all = {} },
      },
      overrides = function(colors) -- add/modify highlights
        return {
          CursorLine = { bg = '#39254a' },
          Comment = { fg = '#6b6b6b', bg = 'NONE', italic = true, bold = true },
          CopilotSuggestion = { bg = 'NONE', link = 'Comment' },
          CopilotAnnotation = { bg = 'NONE', link = 'Comment' },
          Folded = { italic = true, bg = '#39254a', fg = colors.palette.orange },
          FlashLabel = { fg = '#FF0000', bold = true, italic = true, bg = '#1E3A8A' },
          FlashMatch = { bg = 'NONE', fg = colors.palette.purple },
          FlashCurrent = { bg = 'NONE', fg = colors.palette.purple },
          VerticalSplit = { fg = colors.palette.purple, bg = 'NONE' },
          WinSeparator = { fg = colors.palette.purple, bg = 'NONE' },
          SnacksPickerInputerBorder = { bg = 'NONE' },
          SnacksPickerBoxTitle = { bg = 'NONE' },
          SnacksPickerInputBorder = { bg = 'NONE' },
          SnacksPickerInputTitle = { bg = 'NONE' },
          Pmenu = { bg = 'NONE' },
          NvimTreeNormal = { bg = 'NONE' },
          NvimTreeNormalNC = { bg = 'NONE' },
          NvimTreeWinSeparator = { bg = 'NONE', fg = colors.palette.purple },
          BufferLineOffsetSeparator = { bg = 'NONE', fg = colors.palette.purple },
        }
      end,
      theme = 'wave', -- Load "wave" theme
      background = { -- map the value of 'background' option to a theme
        dark = 'wave', -- try "dragon" !
        light = 'lotus',
      },
    }

    -- setup must be called before loading
    vim.cmd 'colorscheme kanagawa'
  end,
}
