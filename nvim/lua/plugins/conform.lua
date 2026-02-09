return {
  "stevearc/conform.nvim",
  opts = {
    formatters_by_ft = {
      lua = { "stylua" },
      -- You can use 'stop_after_first' to run the first available formatter from the list
      javascript = {
        --    "biome-check",
        "biome",
        stop_after_first = true,
      },
      javascriptreact = {
        --    "biome-check",
        "biome",
        stop_after_first = true,
      },
      typescript = {
        --    "biome-check",
        "biome",
        stop_after_first = true,
      },
      typescriptreact = {
        --    "biome-check",
        "biome",
        stop_after_first = true,
      },
      json = {
        --    "biome-check",
        "biome",
        stop_after_first = true,
      },
      css = {
        --    "biome-check",
        "biome",
        stop_after_first = true,
      },
      yaml = {
        --    "biome-check",
        "biome",
        stop_after_first = true,
      },
      graphql = {
        --    "biome-check",
        "biome",
        stop_after_first = true,
      },
      html = {
        --    "biome-check",
        "biome",
        stop_after_first = true,
      },
      jsonc = {
        --    "biome-check",
        "biome",
        stop_after_first = true,
      },
      markdown = {
        --    "biome-check",
        "biome",
        stop_after_first = true,
      },
      bash = {
        "shfmt",
        --    "biome-check",
        "biome",
        stop_after_first = true,
      },
      sh = {
        "shfmt",
        --    "biome-check",
        "biome",
        stop_after_first = true,
      },
      cucumber = { "reformat-gherkin" },
    },
  },
}
