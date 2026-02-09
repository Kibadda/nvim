local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd
local clear = vim.api.nvim_clear_autocmds

local should_confirm = false
local get = vim.lsp.completion.get
--- @diagnostic disable-next-line:duplicate-set-field
function vim.lsp.completion.get()
  should_confirm = false
  get()
end

local groups = {
  highlight = augroup("LspAttachHighlight", { clear = false }),
}

local function feedkeys(keys)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(keys, true, false, true), "n", false)
end

autocmd("LspAttach", {
  group = augroup("LspAttach", { clear = true }),
  callback = function(args)
    local bufnr = args.buf
    local client = vim.lsp.get_client_by_id(args.data.client_id)

    if not client then
      return
    end

    --- @param opts vim.lsp.LocationOpts.OnList
    local function on_list(opts)
      if #opts.items == 0 then
        vim.notify("No location found", vim.log.levels.WARN)
      elseif #opts.items == 1 then
        vim.lsp.util.show_document(opts.items[1].user_data, client.offset_encoding)
      else
        require("mini.pick").registry.lsp {
          title = "Lsp " .. vim.split(opts.title, " ")[1],
          items = opts.items,
        }
      end
    end

    local methods = vim.lsp.protocol.Methods

    --- @type table<string, ({ lhs: string, rhs: function, mode?: string|string[] }|function)[]>
    local maps = {
      [methods.textDocument_definition] = {
        {
          lhs = "gd",
          rhs = function()
            vim.lsp.buf.definition { on_list = on_list }
          end,
        },
        {
          lhs = "gD",
          rhs = function()
            local params = vim.lsp.util.make_position_params(0, client.offset_encoding)
            vim.lsp.buf_request(bufnr, methods.textDocument_definition, params, function(_, result)
              if not result or vim.tbl_isempty(result) then
                return nil
              end

              local buf = vim.lsp.util.preview_location(result[1], {})

              if buf then
                local cur_buf = vim.api.nvim_get_current_buf()
                local filetype = vim.bo[cur_buf].filetype
                if filetype == "php" then
                  filetype = "php_only"
                end
                vim.bo[buf].filetype = filetype
              end
            end)
          end,
        },
      },
      [methods.textDocument_references] = {
        {
          lhs = "grr",
          rhs = function()
            vim.lsp.buf.references({
              includeDeclaration = false,
            }, { on_list = on_list })
          end,
        },
      },
      [methods.textDocument_implementation] = {
        {
          lhs = "gs",
          rhs = function()
            vim.lsp.buf.document_symbol { on_list = on_list }
          end,
        },
      },
      [methods.textDocument_documentSymbol] = {
        {
          lhs = "gI",
          rhs = function()
            vim.lsp.buf.implementation { on_list = on_list }
          end,
        },
      },
      [methods.workspace_symbol] = {
        {
          lhs = "gS",
          rhs = function()
            vim.lsp.buf.workspace_symbol(nil, { on_list = on_list })
          end,
        },
      },
      [methods.textDocument_codeLens] = {
        {
          lhs = "grl",
          rhs = function()
            vim.lsp.codelens.run()
          end,
        },
        function()
          vim.lsp.codelens.enable(true, { bufnr = bufnr })
        end,
      },
      [methods.textDocument_documentHighlight] = {
        function()
          clear { group = groups.highlight, buffer = bufnr }
          autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
            group = groups.highlight,
            buffer = bufnr,
            callback = function()
              vim.lsp.buf.document_highlight()
            end,
          })
          autocmd({ "BufLeave", "CursorMoved", "InsertEnter" }, {
            group = groups.highlight,
            buffer = bufnr,
            callback = function()
              vim.lsp.buf.clear_references()
            end,
          })
        end,
      },
      [methods.textDocument_inlayHint] = {
        {
          lhs = "gri",
          rhs = function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = bufnr }, { bufnr = bufnr })
          end,
        },
      },
      [methods.textDocument_documentColor] = {
        function()
          require("mini.hipatterns").disable(bufnr)
          vim.lsp.document_color.enable(true, bufnr)
        end,
      },
      [methods.textDocument_formatting] = {
        function()
          if not vim.b[bufnr].formatter then
            vim.b[bufnr].formatter = vim.lsp.buf.format
          end
        end,
      },
      [methods.textDocument_selectionRange] = {
        {
          lhs = "<C-Space>",
          mode = { "n", "x" },
          rhs = function()
            vim.lsp.buf.selection_range(1)
          end,
        },
        {
          lhs = "<C-S-Space>",
          mode = "x",
          rhs = function()
            vim.lsp.buf.selection_range(-1)
          end,
        },
      },
      [methods.textDocument_completion] = {
        function()
          vim.lsp.completion.enable(true, client.id, bufnr, {
            autotrigger = true,
            convert = function(item)
              local word = item.label

              if item.insertTextFormat == vim.lsp.protocol.InsertTextFormat.Snippet then
                word = (item.insertText or item.label):gsub("%b()", "")
              elseif item.textEdit then
                word = item.textEdit.newText:match "^(%S*)" or item.textEdit.newText
              elseif item.insertText and item.insertText ~= "" then
                word = item.insertText
              end

              return {
                abbr = item.label:gsub("%b()", ""),
                word = word,
              }
            end,
          })
        end,
        {
          mode = "i",
          lhs = "<C-Space>",
          rhs = function()
            vim.lsp.completion.get()
          end,
        },
        {
          mode = "i",
          lhs = "<CR>",
          rhs = function()
            if vim.fn.pumvisible() == 1 then
              local info = vim.fn.complete_info()

              if info.selected == -1 or not should_confirm then
                feedkeys "<C-e><CR>"
              else
                feedkeys "<C-y>"
              end
            else
              feedkeys "<CR>"
            end
          end,
        },
        {
          mode = { "i", "s" },
          lhs = "<Tab>",
          rhs = function()
            local function has_words_before()
              local line, col = unpack(vim.api.nvim_win_get_cursor(0))
              return col ~= 0 and not vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match "%s"
            end

            if vim.fn.pumvisible() == 1 then
              should_confirm = true
              feedkeys "<C-n>"
            elseif has_words_before() then
              vim.lsp.completion.get()
            else
              feedkeys "<Tab>"
            end
          end,
        },
        {
          mode = { "i", "s" },
          lhs = "<S-Tab>",
          rhs = function()
            if vim.fn.pumvisible() == 1 then
              should_confirm = true
              feedkeys "<C-p>"
            else
              feedkeys "<S-Tab>"
            end
          end,
        },
      },
      [methods.textDocument_inlineCompletion] = {
        {
          mode = "i",
          lhs = "<C-z>",
          rhs = function()
            if vim.lsp.inline_completion.is_enabled { bufnr = bufnr } then
              vim.lsp.inline_completion.enable(false, { bufnr = bufnr })
            else
              feedkeys "<C-e>"
              vim.lsp.inline_completion.enable(true, { bufnr = bufnr })
              vim.lsp.inline_completion.select { bufnr = bufnr, count = 0 }
            end
          end,
        },
        {
          mode = "i",
          lhs = "<C-S-Space>",
          rhs = function()
            if vim.lsp.inline_completion.is_enabled { bufnr = bufnr } then
              vim.lsp.inline_completion.get { bufnr = bufnr }
              vim.lsp.inline_completion.enable(false, { bufnr = bufnr })
            end
          end,
        },
      },
    }

    for method, mappings in pairs(maps) do
      if method == "_" or client:supports_method(method) then
        for _, mapping in ipairs(mappings) do
          if type(mapping) == "table" then
            vim.keymap.set(mapping.mode or "n", mapping.lhs, mapping.rhs, {
              buffer = bufnr,
            })
          else
            mapping()
          end
        end
      end
    end
  end,
})
