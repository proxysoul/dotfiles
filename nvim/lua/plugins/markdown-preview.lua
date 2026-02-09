return {
  "MeanderingProgrammer/render-markdown.nvim", -- Make Markdown buffers look beautiful
  ft = { "markdown", "codecompanion" },
  opts = {
    render_modes = true, -- Render in ALL modes
    sign = {
      enabled = false, -- Turn off in the status column
    },
  },
}
