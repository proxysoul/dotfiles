return {
  "miversen33/sunglasses.nvim",
  config = true,
  event = "UIEnter",
  opts = {
    filter_type = "SHADE",
    filter_percent = 0.6,
    excluded_filetypes = {
      "snacks_picker_list",
      "snacks_picker_input",
    },
  },
}
