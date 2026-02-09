return {
  "mistricky/codesnap.nvim",
  build = "make",
  event = "BufRead",
  keys = {
    { "<leader>cå", "<cmd>CodeSnap<cr>", mode = "x", desc = "Save selected code snapshot into clipboard" },
  },
  opts = {
    save_path = "~/Desktop/code-snap",
    has_breadcrumbs = false,
    bg_theme = "summer",
    watermark = "",
    bg_x_padding = 8,
    bg_y_padding = 8,
    has_line_number = false,
    show_workspace = false,
  },
}
