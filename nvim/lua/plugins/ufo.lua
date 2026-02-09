return {
  "kevinhwang91/nvim-ufo",
  lazy = false,
  event = "BufReadPost",
  dependencies = {
    "kevinhwang91/promise-async",
  },
  opts = {
    -- Custom fold virtual text with nice icon and arrow
    fold_virt_text_handler = function(virtText, lnum, endLnum, width, truncate)
      local newVirtText = {}
      local suffix = (" 󰁂  %d lines"):format(endLnum - lnum)
      local sufWidth = vim.fn.strdisplaywidth(suffix)
      local targetWidth = width - sufWidth
      local curWidth = 0

      for _, chunk in ipairs(virtText) do
        local chunkText = chunk[1]
        local chunkWidth = vim.fn.strdisplaywidth(chunkText)
        if targetWidth > curWidth + chunkWidth then
          table.insert(newVirtText, chunk)
        else
          chunkText = truncate(chunkText, targetWidth - curWidth)
          local hlGroup = chunk[2]
          table.insert(newVirtText, { chunkText, hlGroup })
          chunkWidth = vim.fn.strdisplaywidth(chunkText)
          if curWidth + chunkWidth < targetWidth then
            suffix = suffix .. (" "):rep(targetWidth - curWidth - chunkWidth)
          end
          break
        end
        curWidth = curWidth + chunkWidth
      end

      table.insert(newVirtText, { suffix, "MoreMsg" })
      return newVirtText
    end,

    -- Provider priority
    -- provider_selector = function(bufnr, filetype, buftype)
    --   return { "treesitter", "indent" }
    -- end,

    -- Auto-close imports and comments when opening files
    close_fold_kinds_for_ft = {
      default = { "imports", "comment" },
      python = { "imports" },
      javascript = { "imports", "comment" },
      typescript = { "imports", "comment" },
      json = { "array" },
      javascriptreact = { "imports", "comment" },
      typescriptreact = { "imports", "comment" },
      lua = { "imports", "comment" },
      rust = { "imports", "comment" },
      go = { "imports", "comment" },
    },

    -- Preview window with nice border
    preview = {
      win_config = {
        border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
        winblend = 0,
        winhighlight = "Normal:Folded",
      },
      mappings = {
        scrollU = "<C-u>",
        scrollD = "<C-d>",
        jumpTop = "[",
        jumpBot = "]",
      },
    },
  },

  init = function()
    -- Using ufo provider needs a large value for foldlevel
    vim.o.foldlevel = 99
    vim.o.foldlevelstart = 99
    vim.o.foldenable = true

    -- Set foldcolumn to show fold indicators
    vim.o.foldcolumn = "1"

    -- Ensure fillchars are set for fold icons
    vim.opt.fillchars = {
      -- foldopen = "",
      -- foldclose = "",
      fold = " ",
      foldsep = " ",
      diff = "╱",
      eob = " ",
    }
  end,

  config = function(_, opts)
    -- Setup nvim-ufo
    require("ufo").setup(opts)

    -- Keymaps
    vim.keymap.set("n", "zR", require("ufo").openAllFolds, { desc = "Open all folds" })
    vim.keymap.set("n", "zM", require("ufo").closeAllFolds, { desc = "Close all folds" })
    vim.keymap.set("n", "zr", require("ufo").openFoldsExceptKinds, { desc = "Open folds except kinds" })
    vim.keymap.set("n", "zm", require("ufo").closeFoldsWith, { desc = "Close folds with" })

    -- Peek fold or show LSP hover
    vim.keymap.set("n", "zK", function()
      local winid = require("ufo").peekFoldedLinesUnderCursor()
      if not winid then
        vim.lsp.buf.hover()
      end
    end, { desc = "Peek fold or hover" })
  end,
}
