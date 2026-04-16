-- ------------------------------------------------------------------
-- AI POLICY (startup-only)
-- ------------------------------------------------------------------

local function ai_allowed()
  local cwd = vim.fn.getcwd()

  local allowed_paths = {
    vim.fn.expand("~/.config"),
    vim.fn.expand("~/dotfiles"),
  }

  local env_paths = vim.env.NVIM_AI_ALLOWED_PATHS
  if env_paths and env_paths ~= "" then
    for path in env_paths:gmatch("([^,]+)") do
      table.insert(allowed_paths, vim.fn.expand(path))
    end
  end

  for _, path in ipairs(allowed_paths) do
    if cwd:sub(1, #path) == path then
      return true
    end
  end

  return false
end

local ENABLE_AI = ai_allowed()

-- ------------------------------------------------------------------
-- PLUGINS
-- ------------------------------------------------------------------

return {

  ------------------------------------------------------------------
  -- Copilot
  ------------------------------------------------------------------
  {
    "zbirenbaum/copilot.lua",
    cond = ENABLE_AI,
    lazy = true,
    event = "InsertEnter",
    cmd = "Copilot",
    build = ":Copilot auth",
    dependencies = {
      {
        "copilotlsp-nvim/copilot-lsp",
        lazy = false,
        init = function()
          vim.g.copilot_nes_debounce = 500
          vim.lsp.enable("copilot_ls")
          vim.keymap.set("n", "<c-y>", function()
            local bufnr = vim.api.nvim_get_current_buf()
            local state = vim.b[bufnr].nes_state
            if state then
              -- Try to jump to the start of the suggestion edit.
              -- If already at the start, then apply the pending suggestion and jump to the end of the edit.
              local _ = require("copilot-lsp.nes").walk_cursor_start_edit()
                or (
                  require("copilot-lsp.nes").apply_pending_nes()
                  and require("copilot-lsp.nes").walk_cursor_end_edit()
                )
              return nil
            else
              -- Resolving the terminal's inability to distinguish between `TAB` and `<C-i>` in normal mode
              return "<C-i>"
            end
          end, { desc = "Accept Copilot NES suggestion", expr = true })
        end,
      },
    },
    requires = {
      "copilotlsp-nvim/copilot-lsp",
    },
    opts = {
      -- copilot_model = "gpt-4o-copilot",
      nes = {
        enabled = true,
      },
      should_attach = function(_, bufname)
        if string.match(bufname, "env") then
          return false
        end

        return true
      end,
      panel = {
        enabled = false,
        auto_refresh = false,
      },
      suggestion = {
        enabled = true,
        auto_trigger = true,
        hide_during_completion = true,
        accept = false,
        -- keymap = {
        --   accept = false,
        -- },
      },
      server = {
        type = "binary",
      },
      filetypes = {
        sh = function()
          if string.match(vim.fs.basename(vim.api.nvim_buf_get_name(0)), "^%.env") then
            -- disable for .env files
            return false
          end
          return true
        end,
      },
      server_opts_overrides = {
        trace = "verbose",
        settings = {
          advanced = {
            listCount = 10, -- #completions for panel
            inlineSuggestCount = 3, -- #completions for getCompletions
          },
        },
      },
      workspace_folders = {},
    },

    config = function(_, opts)
      require("copilot").setup(opts)
      --
      -- local nes = require("copilot-lsp.nes")
      --
      -- ---@param client vim.lsp.Client
      -- ---@param au integer
      -- function nes.lsp_on_init(client, au)
      --   local debounced_request = require("copilot-lsp.util").debounce(
      --     require("copilot-lsp.nes").request_nes,
      --     vim.g.copilot_nes_debounce or 500
      --   )
      --   vim.api.nvim_create_autocmd({ "InsertLeave", "TextChanged" }, {
      --     callback = function()
      --       debounced_request(client)
      --     end,
      --     group = au,
      --   })
      --
      --   vim.api.nvim_create_autocmd("BufEnter", {
      --     callback = function()
      --       local td_params = vim.lsp.util.make_text_document_params()
      --       client:notify("textDocument/didFocus", {
      --         textDocument = {
      --           uri = td_params.uri,
      --         },
      --       })
      --     end,
      --     group = au,
      --   })
      -- end

      -- Hide Copilot when cmp menu is open
      -- local ok, cmp = pcall(require, "cmp")
      -- if ok then
      --   cmp.event:on("menu_opened", function()
      --     vim.b.copilot_suggestion_hidden = true
      --   end)
      --   cmp.event:on("menu_closed", function()
      --     vim.b.copilot_suggestion_hidden = false
      --   end)
      -- end
    end,
  },

  ------------------------------------------------------------------
  -- CodeCompanion
  ------------------------------------------------------------------
  {
    "olimorris/codecompanion.nvim",
    cond = ENABLE_AI,
    lazy = false,

    dependencies = {
      "nvim-lua/plenary.nvim",
      "ravitemer/mcphub.nvim",
    },

    config = function()
      require("utils.spinner"):init()

      require("codecompanion").setup({
        strategies = {
          chat = {
            name = "copilot",
            model = "GPT-5.2",
            tools = {
              opts = {
                auto_submit_errors = true,
                auto_submit_success = true,
                system_prompt = {
                  enabled = true,
                  replace_main_system_prompt = false,
                  prompt = function()
                    return table.concat({
                      "Rules:",
                      "Always use tools to edit files.",
                      "Never use <casting> or <any> in TypeScript.",
                      "Never mute lint rules.",
                      "Use makeStyles & mergeClasses from Fluent v9.",
                      "Never use inline styling.",
                      "Always use <type> instead of <interface>.",
                      "No need to document changes in md files unless instructed",
                    }, " ")
                  end,
                },
              },
            },
            icons = {
              buffer_pin = " ",
              buffer_watch = "👀 ",
            },
            slash_commands = {
              file = {
                opts = {
                  provider = "snacks", -- Can be "default", "telescope", "fzf_lua", "mini_pick" or "snacks"
                },
              },
              git_files = {
                description = "List git files",
                callback = function(chat)
                  local handle = io.popen("git ls-files")
                  if not handle then
                    return vim.notify("No git files available", vim.log.levels.INFO, { title = "CodeCompanion" })
                  end
                  local result = handle:read("*a")
                  handle:close()
                  chat:add_context({ role = "user", content = result }, "git", "<git_files>")
                end,
                opts = { contains_code = false },
              },
              buffer = {
                keymaps = {
                  modes = {
                    i = "<C-b>",
                    n = { "<C-b>", "gb" },
                  },
                },
              },
            },
            roles = {
              llm = function(adapter)
                return "CodeCompanion (" .. adapter.formatted_name .. ")"
              end,
              user = "Me",
            },
          },
          inline = { adapter = "copilot" },
          cmd = { adapter = "copilot" },
        },
        opts = {
          log_level = "DEBUG",
          show_model_choices = true,
        },
        display = {
          action_palette = {
            width = 95,
            height = 10,
            prompt = "Prompt ", -- Prompt used for interactive LLM calls
            provider = "default", -- Can be "default", "telescope", "fzf_lua", "mini_pick" or "snacks". If not specified, the plugin will autodetect installed providers.
            opts = {
              show_default_actions = true, -- Show the default actions in the action palette?
              show_default_prompt_library = true, -- Show the default prompt library in the action palette?
              title = "CodeCompanion actions", -- The title of the action palette
            },
          },
          chat = {
            icons = {
              chat_context = "📎️", -- You can also apply an icon to the fold
            },
            opts = {
              wrap = true,
              number = false,
              relativenumber = false,
            },
            fold_context = true,
            fold_reasoning = true,
            intro_message = "Welcome✨! Press ? for options",
            separator = "─", -- The separator between the different messages in the chat buffer
            show_context = true, -- Show context (from slash commands and variables) in the chat buffer?
            show_header_separator = false, -- Show header separators in the chat buffer? Set this to false if you're using an external markdown formatting plugin
            show_settings = true, -- Show LLM settings at the top of the chat buffer?
            show_token_count = true, -- Show the token count for each response?
            show_tools_processing = true, -- Show the loading message when tools are being executed?
            start_in_insert_mode = true, -- Open the chat buffer in insert mode?
            child_window = {
              width = vim.o.columns - 5,
              height = vim.o.lines - 2,
              row = "center",
              col = "center",
              relative = "editor",
              opts = {
                wrap = true,
                number = false,
                relativenumber = false,
              },
            },
            window = {
              opts = {
                breakindent = true,
                cursorcolumn = false,
                cursorline = false,
                foldcolumn = "0",
                linebreak = true,
                list = false,
                numberwidth = 1,
                signcolumn = "no",
                spell = false,
                wrap = true,
                number = false,
                relativenumber = false,
              },
            },
          },
        },
        interactions = {
          chat = {
            adapter = {
              name = "copilot",
              model = "GPT-5.2",
            },
            opts = {
              completion_provider = "blink",
            },
            variables = {
              ["buffer"] = {
                opts = {
                  default_params = "all",
                },
              },
            },
          },
        },
        extensions = {
          mcphub = {
            callback = "mcphub.extensions.codecompanion",
            opts = {
              make_vars = true,
              make_slash_commands = true,
              show_result_in_chat = true,
            },
          },
        },
      })
    end,
  },
}
