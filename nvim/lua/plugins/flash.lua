return {
  "folke/flash.nvim",
  event = "VeryLazy",
  keys = {
    {
      "s",
      mode = { "n", "x", "o" },
      function()
        require("flash").jump({ search = { forward = true, wrap = true, multi_window = false } })
      end,
      desc = "Flash",
      nowait = true,
    },
    {
      "S",
      mode = { "n", "x", "o" },
      function()
        require("flash").treesitter()
      end,
      desc = "Flash Treesitter",
      nowait = true,
    },
  },
}
