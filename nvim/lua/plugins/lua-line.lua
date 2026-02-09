return {
  "nvim-lualine/lualine.nvim",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
    "Tsuzat/NeoSolarized.nvim",
    "AndreM222/copilot-lualine",
    "f-person/git-blame.nvim",
  },
  opts = {},
  opts = function(_, opts)
    local git_blame = require("gitblame")

    local copilot = {
      "copilot",
      -- Default values
      symbols = {
        status = {
          icons = {
            enabled = " ",
            sleep = " ", -- auto-trigger disabled
            disabled = " ",
            warning = " ",
            unknown = " ",
          },
          hl = {
            enabled = "#50FA7B",
          },
        },
      },
    }

    table.insert(opts.sections.lualine_a, copilot)

    local function getBlame()
      if git_blame.get_current_blame_text() == nil then
        return [[LazyPouiiro Zzz]]
      end
      return git_blame.get_current_blame_text()
    end

    opts.sections.lualine_y = {}
    opts.sections.lualine_c = {}
    opts.sections.lualine_x = {}
    opts.sections.lualine_z = {}
    opts.sections.lualine_b = {}

    table.insert(opts.sections.lualine_z, {
      function()
        return getBlame()
      end,
    })

    table.insert(opts.sections.lualine_c, {
      "filename",
      path = 1,
    })

    table.insert(opts.sections.lualine_z, {
      "branch",
    })

    local light = require("NeoSolarized.config").is_day()
    local palette = require("NeoSolarized.colors").dark

    if light then
      palette = require("NeoSolarized.colors").light
    end

    local theme = {
      normal = {
        a = { bg = palette.blue, fg = palette.bg0, gui = "bold" },
        b = { bg = light and palette.bg1 or palette.bg0, fg = light and palette.base3 or palette.fg0 },
        c = { bg = light and palette.bg1 or palette.bg0, fg = light and palette.base3 or palette.fg0 },
      },
      insert = {
        a = { bg = palette.bg_green, fg = palette.bg0, gui = "bold" },
        b = { bg = light and palette.bg1 or palette.bg0, fg = light and palette.base3 or palette.fg0 },
        c = { bg = light and palette.bg1 or palette.bg0, fg = light and palette.base3 or palette.fg0 },
      },
      visual = {
        a = { bg = palette.bg_red, fg = palette.bg0, gui = "bold" },
        b = { bg = light and palette.bg1 or palette.bg0, fg = light and palette.base3 or palette.fg0 },
        c = { bg = light and palette.bg1 or palette.bg0, fg = light and palette.base3 or palette.fg0 },
      },
      replace = {
        a = { bg = palette.bg_yellow, fg = palette.bg0, gui = "bold" },
        b = { bg = light and palette.bg1 or palette.bg0, fg = light and palette.base3 or palette.fg0 },
        c = { bg = light and palette.bg1 or palette.bg0, fg = light and palette.base3 or palette.fg0 },
      },
      command = {
        a = { bg = palette.blue, fg = palette.bg0, gui = "bold" },
        b = { bg = light and palette.bg1 or palette.bg0, fg = light and palette.base3 or palette.fg0 },
        c = { bg = light and palette.bg1 or palette.bg0, fg = light and palette.base3 or palette.fg0 },
      },
      terminal = {
        a = { bg = palette.purple, fg = palette.bg0, gui = "bold" },
        b = { bg = light and palette.bg1 or palette.bg0, fg = light and palette.base3 or palette.fg0 },
        c = { bg = light and palette.bg1 or palette.bg0, fg = light and palette.base3 or palette.fg0 },
      },
      inactive = {
        a = { bg = palette.bg0, fg = palette.fg0, gui = "bold" },
        b = { bg = light and palette.bg1 or palette.bg0, fg = light and palette.base3 or palette.fg0 },
        c = { bg = light and palette.bg1 or palette.bg0, fg = light and palette.base3 or palette.fg0 },
      },
    }

    local lualine_modes = { "insert", "normal", "visual", "command", "replace", "inactive", "terminal" }

    for _, field in ipairs(lualine_modes) do
      if theme[field] and theme[field].c then
        theme[field].c.bg = "NONE"
      end
      if theme[field] and theme[field].b then
        theme[field].b.bg = "NONE"
      end
    end

    local extraOpts = {
      options = {
        theme = theme,
      },
    }

    opts = vim.tbl_deep_extend("force", opts, extraOpts)

    return opts
  end,
}
