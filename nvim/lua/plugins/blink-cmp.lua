return {
  "saghen/blink.cmp",
  dependencies = {
    -- "giuxtaposition/blink-cmp-copilot",
  },
  opts = {
    -- fuzzy = { implementation = "lua" },
    completion = {
      menu = { border = "rounded" },
      documentation = { window = { border = "rounded" } },
    },
    signature = { window = { border = "rounded" } },
    keymap = {
      ["<C-y>"] = false,
      ["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
      -- ["<Tab>"] = {
      --   function(cmp)
      --     if vim.b[vim.api.nvim_get_current_buf()].nes_state then
      --       cmp.hide()
      --       return (
      --         require("copilot-lsp.nes").apply_pending_nes()
      --         and require("copilot-lsp.nes").walk_cursor_end_edit()
      --       )
      --     end
      --     if cmp.snippet_active() then
      --       return cmp.accept()
      --     else
      --       return cmp.select_and_accept()
      --     end
      --   end,
      --   "select_next",
      --   "snippet_forward",
      --   "fallback",
      -- },
      ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
    },
    sources = {
      default = {
        "ecolog",
        "lsp",
        "path",
        "snippets",
        "buffer",
        -- "copilot"
      },
      providers = {
        ecolog = { name = "ecolog", module = "ecolog.integrations.cmp.blink_cmp" },
        -- copilot = {
        --   name = "copilot",
        --   module = "blink-cmp-copilot",
        --   score_offset = 100,
        --   async = true,
        -- },
      },
    },
  },
}
