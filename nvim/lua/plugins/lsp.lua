return {
  "neovim/nvim-lspconfig",
  ---@class PluginLspOpts
  opts = function(_, opts)
    opts.servers = vim.tbl_deep_extend("force", opts.servers or {}, {
      ["*"] = {
        { "<leader-ca>", false },
        { "<leader-cA>", false },
      },
    })

    opts.inlay_hints = { enabled = false }

    opts.diagnostics = {
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
    }
  end,
}
