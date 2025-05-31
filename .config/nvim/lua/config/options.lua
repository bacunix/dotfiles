-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.opt.syntax = "enable"
vim.opt.compatible = false
vim.opt.clipboard = "unnamedplus"
vim.opt.mouse = "a"
vim.opt.termguicolors = false;
vim.g.lazyvim_picker = "fzf"
vim.opt.backup = false
vim.opt.laststatus = 3
vim.opt.list = true
vim.opt.wrap = true
vim.opt.backspace = { "start", "eol", "indent" }
vim.opt.title = true
vim.o.tabstop = 4 -- A TAB character looks like 4 spaces
vim.o.expandtab = true -- Pressing the TAB key will insert spaces instead of a TAB character
vim.o.softtabstop = 4 -- Number of spaces inserted instead of a TAB character
vim.o.shiftwidth = 4 -- Number of spaces inserted when indenting
vim.opt.ruler = true
vim.schedule(function()
    vim.api.nvim_set_hl(0, "LineNrAbove", { fg = "#ffffff" })
    vim.api.nvim_set_hl(0, "LineNrBelow", { fg = "#ead84e" })
    vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
    vim.api.nvim_set_hl(0, "Comment", {fg = "#a6afba"})
end)



opts = function(_, opts)
  local fzf = require("fzf-lua")
  local config = fzf.config
  local actions = fzf.actions

  -- Quickfix
  config.defaults.keymap.fzf["ctrl-q"] = "select-all+accept"
  config.defaults.keymap.fzf["ctrl-u"] = "half-page-up"
  config.defaults.keymap.fzf["ctrl-d"] = "half-page-down"
  config.defaults.keymap.fzf["ctrl-x"] = "jump"
  config.defaults.keymap.fzf["ctrl-f"] = "preview-page-down"
  config.defaults.keymap.fzf["ctrl-b"] = "preview-page-up"
  config.defaults.keymap.builtin["<c-f>"] = "preview-page-down"
  config.defaults.keymap.builtin["<c-b>"] = "preview-page-up"

  -- Trouble
  if LazyVim.has("trouble.nvim") then
    config.defaults.actions.files["ctrl-t"] = require("trouble.sources.fzf").actions.open
  end

  -- Toggle root dir / cwd
  config.defaults.actions.files["ctrl-r"] = function(_, ctx)
    local o = vim.deepcopy(ctx.__call_opts)
    o.root = o.root == false
    o.cwd = nil
    o.buf = ctx.__CTX.bufnr
    LazyVim.pick.open(ctx.__INFO.cmd, o)
  end
  config.defaults.actions.files["alt-c"] = config.defaults.actions.files["ctrl-r"]
  config.set_action_helpstr(config.defaults.actions.files["ctrl-r"], "toggle-root-dir")

  local img_previewer ---@type string[]?
  for _, v in ipairs({
    { cmd = "ueberzug", args = {} },
    { cmd = "chafa", args = { "{file}", "--format=symbols" } },
    { cmd = "viu", args = { "-b" } },
  }) do
    if vim.fn.executable(v.cmd) == 1 then
      img_previewer = vim.list_extend({ v.cmd }, v.args)
      break
    end
  end

  return {
    "default-title",
    fzf_colors = true,
    fzf_opts = {
      ["--no-scrollbar"] = true,
    },
    defaults = {
      -- formatter = "path.filename_first",
      formatter = "path.dirname_first",
    },
    previewers = {
      builtin = {
        extensions = {
          ["png"] = img_previewer,
          ["jpg"] = img_previewer,
          ["jpeg"] = img_previewer,
          ["gif"] = img_previewer,
          ["webp"] = img_previewer,
        },
        ueberzug_scaler = "fit_contain",
      },
    },
    -- Custom LazyVim option to configure vim.ui.select
    ui_select = function(fzf_opts, items)
      return vim.tbl_deep_extend("force", fzf_opts, {
        prompt = " ",
        winopts = {
          title = " " .. vim.trim((fzf_opts.prompt or "Select"):gsub("%s*:%s*$", "")) .. " ",
          title_pos = "center",
        },
      }, fzf_opts.kind == "codeaction" and {
        winopts = {
          layout = "vertical",
          -- height is number of items minus 15 lines for the preview, with a max of 80% screen height
          height = math.floor(math.min(vim.o.lines * 0.8 - 16, #items + 2) + 0.5) + 16,
          width = 0.5,
          preview = not vim.tbl_isempty(LazyVim.lsp.get_clients({ bufnr = 0, name = "vtsls" })) and {
            layout = "vertical",
            vertical = "down:15,border-top",
            hidden = "hidden",
          } or {
            layout = "vertical",
            vertical = "down:15,border-top",
          },
        },
      } or {
        winopts = {
          width = 0.5,
          -- height is number of items, with a max of 80% screen height
          height = math.floor(math.min(vim.o.lines * 0.8, #items + 2) + 0.5),
        },
      })
    end,
    winopts = {
      width = 0.8,
      height = 0.8,
      row = 0.5,
      col = 0.5,
      preview = {
        scrollchars = { "┃", "" },
      },
    },
    files = {
      cwd_prompt = false,
      actions = {
        ["alt-i"] = { actions.toggle_ignore },
        ["alt-h"] = { actions.toggle_hidden },
      },
    },
    grep = {
      actions = {
        ["alt-i"] = { actions.toggle_ignore },
        ["alt-h"] = { actions.toggle_hidden },
      },
    },
    lsp = {
      symbols = {
        symbol_hl = function(s)
          return "TroubleIcon" .. s
        end,
        symbol_fmt = function(s)
          return s:lower() .. "\t"
        end,
        child_prefix = false,
      },
      code_actions = {
        previewer = vim.fn.executable("delta") == 1 and "codeaction_native" or nil,
      },
    },
  }
end

opts = function()
  local Keys = require("lazyvim.plugins.lsp.keymaps").get()
  -- stylua: ignore
  vim.list_extend(Keys, {
    { "gd", "<cmd>FzfLua lsp_definitions     jump1=true ignore_current_line=true<cr>", desc = "Goto Definition", has = "definition" },
    { "gr", "<cmd>FzfLua lsp_references      jump1=true ignore_current_line=true<cr>", desc = "References", nowait = true },
    { "gI", "<cmd>FzfLua lsp_implementations jump1=true ignore_current_line=true<cr>", desc = "Goto Implementation" },
    { "gy", "<cmd>FzfLua lsp_typedefs        jump1=true ignore_current_line=true<cr>", desc = "Goto T[y]pe Definition" },
  })
end

opts = {
  -- make sure mason installs the server
  servers = {
    --- @deprecated -- tsserver renamed to ts_ls but not yet released, so keep this for now
    --- the proper approach is to check the nvim-lspconfig release version when it's released to determine the server name dynamically
    tsserver = {
      enabled = false,
    },
    ts_ls = {
      enabled = false,
    },
    vtsls = {
      -- explicitly add default filetypes, so that we can extend
      -- them in related extras
      filetypes = {
        "javascript",
        "javascriptreact",
        "javascript.jsx",
        "typescript",
        "typescriptreact",
        "typescript.tsx",
      },
      settings = {
        complete_function_calls = true,
        vtsls = {
          enableMoveToFileCodeAction = true,
          autoUseWorkspaceTsdk = true,
          experimental = {
            maxInlayHintLength = 30,
            completion = {
              enableServerSideFuzzyMatch = true,
            },
          },
        },
        typescript = {
          updateImportsOnFileMove = { enabled = "always" },
          suggest = {
            completeFunctionCalls = true,
          },
          inlayHints = {
            enumMemberValues = { enabled = true },
            functionLikeReturnTypes = { enabled = true },
            parameterNames = { enabled = "literals" },
            parameterTypes = { enabled = true },
            propertyDeclarationTypes = { enabled = true },
            variableTypes = { enabled = false },
          },
        },
      },
      keys = {
        {
          "gD",
          function()
            local params = vim.lsp.util.make_position_params()
            LazyVim.lsp.execute({
              command = "typescript.goToSourceDefinition",
              arguments = { params.textDocument.uri, params.position },
              open = true,
            })
          end,
          desc = "Goto Source Definition",
        },
        {
          "gR",
          function()
            LazyVim.lsp.execute({
              command = "typescript.findAllFileReferences",
              arguments = { vim.uri_from_bufnr(0) },
              open = true,
            })
          end,
          desc = "File References",
        },
        {
          "<leader>co",
          LazyVim.lsp.action["source.organizeImports"],
          desc = "Organize Imports",
        },
        {
          "<leader>cM",
          LazyVim.lsp.action["source.addMissingImports.ts"],
          desc = "Add missing imports",
        },
        {
          "<leader>cu",
          LazyVim.lsp.action["source.removeUnused.ts"],
          desc = "Remove unused imports",
        },
        {
          "<leader>cD",
          LazyVim.lsp.action["source.fixAll.ts"],
          desc = "Fix all diagnostics",
        },
        {
          "<leader>cV",
          function()
            LazyVim.lsp.execute({ command = "typescript.selectTypeScriptVersion" })
          end,
          desc = "Select TS workspace version",
        },
      },
    },
  },
  setup = {
    --- @deprecated -- tsserver renamed to ts_ls but not yet released, so keep this for now
    --- the proper approach is to check the nvim-lspconfig release version when it's released to determine the server name dynamically
    tsserver = function()
      -- disable tsserver
      return true
    end,
    ts_ls = function()
      -- disable tsserver
      return true
    end,
    vtsls = function(_, opts)
      LazyVim.lsp.on_attach(function(client, buffer)
        client.commands["_typescript.moveToFileRefactoring"] = function(command, ctx)
          ---@type string, string, lsp.Range
          local action, uri, range = unpack(command.arguments)

          local function move(newf)
            client.request("workspace/executeCommand", {
              command = command.command,
              arguments = { action, uri, range, newf },
            })
          end

          local fname = vim.uri_to_fname(uri)
          client.request("workspace/executeCommand", {
            command = "typescript.tsserverRequest",
            arguments = {
              "getMoveToRefactoringFileSuggestions",
              {
                file = fname,
                startLine = range.start.line + 1,
                startOffset = range.start.character + 1,
                endLine = range["end"].line + 1,
                endOffset = range["end"].character + 1,
              },
            },
          }, function(_, result)
            ---@type string[]
            local files = result.body.files
            table.insert(files, 1, "Enter new path...")
            vim.ui.select(files, {
              prompt = "Select move destination:",
              format_item = function(f)
                return vim.fn.fnamemodify(f, ":~:.")
              end,
            }, function(f)
              if f and f:find("^Enter new path") then
                vim.ui.input({
                  prompt = "Enter move destination:",
                  default = vim.fn.fnamemodify(fname, ":h") .. "/",
                  completion = "file",
                }, function(newf)
                  return newf and move(newf)
                end)
              elseif f then
                move(f)
              end
            end)
          end)
        end
      end, "vtsls")
      -- copy typescript settings to javascript
      opts.settings.javascript =
        vim.tbl_deep_extend("force", {}, opts.settings.typescript, opts.settings.javascript or {})
    end,
  },
}

opts = function(_, opts)
  opts.ensure_installed = opts.ensure_installed or {}
  table.insert(opts.ensure_installed, "js-debug-adapter")
end

opts = {
  file = {
    [".eslintrc.js"] = { glyph = "󰱺", hl = "MiniIconsYellow" },
    [".node-version"] = { glyph = "", hl = "MiniIconsGreen" },
    [".prettierrc"] = { glyph = "", hl = "MiniIconsPurple" },
    [".yarnrc.yml"] = { glyph = "", hl = "MiniIconsBlue" },
    ["eslint.config.js"] = { glyph = "󰱺", hl = "MiniIconsYellow" },
    ["package.json"] = { glyph = "", hl = "MiniIconsGreen" },
    ["tsconfig.json"] = { glyph = "", hl = "MiniIconsAzure" },
    ["tsconfig.build.json"] = { glyph = "", hl = "MiniIconsAzure" },
    ["yarn.lock"] = { glyph = "", hl = "MiniIconsBlue" },
  },
}

opts = function()
  local dap = require("dap")
  if not dap.adapters["pwa-node"] then
    require("dap").adapters["pwa-node"] = {
      type = "server",
      host = "localhost",
      port = "${port}",
      executable = {
        command = "node",
        -- 💀 Make sure to update this path to point to your installation
        args = {
          LazyVim.get_pkg_path("js-debug-adapter", "/js-debug/src/dapDebugServer.js"),
          "${port}",
        },
      },
    }
  end
  if not dap.adapters["node"] then
    dap.adapters["node"] = function(cb, config)
      if config.type == "node" then
        config.type = "pwa-node"
      end
      local nativeAdapter = dap.adapters["pwa-node"]
      if type(nativeAdapter) == "function" then
        nativeAdapter(cb, config)
      else
        cb(nativeAdapter)
      end
    end
  end

  local js_filetypes = { "typescript", "javascript", "typescriptreact", "javascriptreact" }

  local vscode = require("dap.ext.vscode")
  vscode.type_to_filetypes["node"] = js_filetypes
  vscode.type_to_filetypes["pwa-node"] = js_filetypes

  for _, language in ipairs(js_filetypes) do
    if not dap.configurations[language] then
      dap.configurations[language] = {
        {
          type = "pwa-node",
          request = "launch",
          name = "Launch file",
          program = "${file}",
          cwd = "${workspaceFolder}",
        },
        {
          type = "pwa-node",
          request = "attach",
          name = "Attach",
          processId = require("dap.utils").pick_process,
          cwd = "${workspaceFolder}",
        },
      }
    end
  end
end


opts = function(_, opts)
  if not vim.g.trouble_lualine then
    table.insert(opts.sections.lualine_c, { "navic", color_correction = "dynamic" })
  end
end


opts = function()
  return {
    separator = " ",
    highlight = true,
    depth_limit = 5,
    icons = LazyVim.config.icons.kinds,
    lazy_update_context = true,
  }
end

opts = {
  sources = { "filesystem", "buffers", "git_status" },
  open_files_do_not_replace_types = { "terminal", "Trouble", "trouble", "qf", "Outline" },
  filesystem = {
    bind_to_cwd = false,
    follow_current_file = { enabled = true },
    use_libuv_file_watcher = true,
  },
  window = {
    mappings = {
      ["l"] = "open",
      ["h"] = "close_node",
      ["<space>"] = "none",
      ["Y"] = {
        function(state)
          local node = state.tree:get_node()
          local path = node:get_id()
          vim.fn.setreg("+", path, "c")
        end,
        desc = "Copy Path to Clipboard",
      },
      ["O"] = {
        function(state)
          require("lazy.util").open(state.tree:get_node().path, { system = true })
        end,
        desc = "Open with System Application",
      },
      ["P"] = { "toggle_preview", config = { use_float = false } },
    },
  },
  default_component_configs = {
    indent = {
      with_expanders = true, -- if nil and file nesting is enabled, will enable expanders
      expander_collapsed = "",
      expander_expanded = "",
      expander_highlight = "NeoTreeExpander",
    },
    git_status = {
      symbols = {
        unstaged = "󰄱",
        staged = "󰱒",
      },
    },
  },
}



--[[ vim.g.airline_theme = 'onedark'
vim.g.airline_powerline_fonts = 1
vim.g['airline#extensions#tabline#left_sep'] = ' '
vim.g['airline#extensions#tabline#left_alt_sep'] = ''

vim.g['airline#extensions#branch#enabled'] = 1      -- Nhánh Git
vim.g['airline#extensions#hunks#enabled'] = 1       -- Git diff (+/-/~)
vim.g['airline#extensions#ale#enabled'] = 1         -- Hiện lỗi nếu dùng ALE
vim.g['airline#extensions#lsp#enabled'] = 1         -- Hiện lỗi nếu dùng LSP
vim.g['airline#extensions#tabline#enabled'] = 1     -- Bật tabline
vim.g['airline#extensions#tabline#formatter'] = 'unique_tail' ]]
