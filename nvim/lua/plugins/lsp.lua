return {
  "neovim/nvim-lspconfig",
  ---@class PluginLspOpts
  opts = {
    servers = {
      ["*"] = {
        {
          "<leader-ca>",
          false,
        },
        {
          "<leader-cA>",
          false,
        },
      },
      copilot = {
        enabled = true,
      },
    },
    inlay_hints = { enabled = false },
    diagnostics = {
      virtual_text = false,
      severity_sort = true,
      float = { border = "rounded", source = "if_many" },
      signs = vim.g.have_nerd_font and {
        text = {
          [vim.diagnostic.severity.ERROR] = "󰅚 ",
          [vim.diagnostic.severity.WARN] = "󰀪 ",
          [vim.diagnostic.severity.INFO] = "󰋽 ",
          [vim.diagnostic.severity.HINT] = "󰌶 ",
        },
      } or {},
    },
  },
}
