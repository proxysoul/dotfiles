return {
  "nvim-lualine/lualine.nvim",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
    "catppuccin/nvim",
    "AndreM222/copilot-lualine",
    "f-person/git-blame.nvim",
  },
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

    local C = require("catppuccin.palettes").get_palette("mocha")

    local theme = {
      normal = {
        a = { bg = C.blue, fg = C.mantle, gui = "bold" },
        b = { bg = C.surface0, fg = C.blue },
        c = { bg = "NONE", fg = C.text },
      },
      insert = {
        a = { bg = C.green, fg = C.mantle, gui = "bold" },
        b = { bg = C.surface0, fg = C.green },
        c = { bg = "NONE", fg = C.text },
      },
      visual = {
        a = { bg = C.mauve, fg = C.mantle, gui = "bold" },
        b = { bg = C.surface0, fg = C.mauve },
        c = { bg = "NONE", fg = C.text },
      },
      replace = {
        a = { bg = C.red, fg = C.mantle, gui = "bold" },
        b = { bg = C.surface0, fg = C.red },
        c = { bg = "NONE", fg = C.text },
      },
      command = {
        a = { bg = C.peach, fg = C.mantle, gui = "bold" },
        b = { bg = C.surface0, fg = C.peach },
        c = { bg = "NONE", fg = C.text },
      },
      terminal = {
        a = { bg = C.green, fg = C.mantle, gui = "bold" },
        b = { bg = C.surface0, fg = C.green },
        c = { bg = "NONE", fg = C.text },
      },
      inactive = {
        a = { bg = "NONE", fg = C.blue },
        b = { bg = "NONE", fg = C.surface1 },
        c = { bg = "NONE", fg = C.overlay0 },
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
