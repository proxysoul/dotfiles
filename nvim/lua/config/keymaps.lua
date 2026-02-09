-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local map = vim.keymap.set

-- -- TS handlers
-- map("n", "<leader>tu", "<cmd>VtsExec remove_unused_imports<CR>", { desc = "[i] Remove unused imports" })
-- map("n", "<leader>tv", "<cmd>VtsExec remove_unused<CR>", { desc = "[v] Remove unused variables" })
-- map("n", "<leader>ti", "<cmd>VtsExec add_missing_imports<CR>", { desc = "[m] Add missing imports" })
-- map("n", "<leader>tr", "<cmd> VtsExec TSToolsRenameFile<CR>", { desc = "[r] Rename file" })

-- Resize window
map("n", "<C-'>", "<C-w><", { desc = "Resize window left" })
map("n", "<C-ö>", "<C-w>>", { desc = "Resize window right" })
map("n", "<C-ä>", "<C-w>+", { desc = "Resize window up" })
map("n", "<C-å>", "<C-w>-", { desc = "Resize window down" })

-- Movement in insert mode
map("i", "<C-e>", "<C-o>A", { desc = "Move to end of line in insert mode" })
map("i", "<C-i>", "<C-o>I", { desc = "Move to start of line in insert mode" })

-- Select All
vim.keymap.set({ "n", "v" }, "<C-a>", "<cmd>normal! ggVG<CR>", { noremap = true, silent = true, desc = "Select all" })

-- Split window
-- map("n", "ss", ":split<Return>", { desc = "Horizontal split" })
-- map("n", "sv", ":vsplit<Return>", { desc = "Vertical split" })
-- map("n", "sc", "<C-w>q", { desc = "Close split" })

map("n", "<C-b>", function()
  Snacks.picker.buffers()
end, { desc = "show buffers list", silent = true })
map("n", "<leader>sf", "<cmd>TermSelect<cr>", { desc = "Open terminal selector", silent = true, noremap = true })

map("n", "<C-vr>", function()
  vim.cmd("stopinsert | lua vim.lsp.buf.rename()")
end, { desc = "LSP Rename variable" })

map("n", "<leader>sa", function()
  Snacks.picker.pickers()
end, { desc = "Get all pickers" })

map("i", "<C-n>", function()
  require("copilot.suggestion").next()
  vim.notify("Next copilot suggestion", vim.log.levels.INFO, { title = "Copilot" })
end, { noremap = true, desc = "Select next copilot", silent = true })

map({ "i", "c" }, "<C-y>", function()
  require("copilot.suggestion").accept()
end, { noremap = true, desc = "Close cmp and accept copilot", silent = true })

-- Buffer shit (tabs)
-- map("n", "<Tab>", "<cmd>bnext<cr>", { noremap = true, silent = true, desc = "Next buffer" })
-- map("n", "<S-Tab>", "<cmd>bprev<cr>", { noremap = true, silent = true, desc = "Previous buffer" })
map("n", "<C-k>", function()
  Snacks.bufdelete()
end, {
  noremap = true,
  silent = true,
  desc = "Close buffer",
})
--
-- LSP
map("n", "<C-x>", vim.diagnostic.open_float, { noremap = true, silent = true, desc = "Open diagnostic float" })
map("n", "<C-f>", vim.lsp.buf.code_action, { noremap = true, silent = true, desc = "Code actions" })
map("n", "<C-h>", function()
  vim.lsp.buf.hover({ border = "single", max_height = 25, max_width = 120, focusable = false, silent = true })
end, { noremap = true, silent = true, desc = "Hover definition" })
map("n", "<C-j>", vim.lsp.buf.signature_help, { noremap = true, silent = true, desc = "Show doc cmp help" })
map("n", "<C-,>", function()
  vim.diagnostic.jump({ float = true, count = 1 })
end, { noremap = true, silent = true, desc = "Go to next diagnostic" })

map("n", "<C-m>", function()
  vim.diagnostic.jump({ float = true, count = -1 })
end, { noremap = true, silent = true, desc = "Go to previous diagnostic" })

map("n", "<leader>ca", "<cmd>CodeCompanionChat<cr>", { desc = "Code Companion actions", silent = true, noremap = true })
map(
  "n",
  "<leader>cA",
  "<cmd>CodeCompanionActions<cr>",
  { desc = "Code Companion actions", silent = true, noremap = true }
)

map("n", "<C-o>", function()
  -- toggle if oil open, otherwise open
  -- require("oil").open()
  if vim.bo.filetype == "oil" then
    require("oil").close()
  else
    require("oil").open()
  end
end, { desc = "Open Oil file explorer", silent = true, noremap = true })
