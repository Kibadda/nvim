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

    --- @param opts vim.lsp.ListOpts.OnList
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

    local function map(lhs, rhs, mode)
      vim.keymap.set(mode or "n", lhs, rhs, { buffer = bufnr })
    end

    if client:supports_method "textDocument/definition" then
      map("gd", function()
        vim.lsp.buf.definition { on_list = on_list }
      end)
    end

    if client:supports_method "textDocument/references" then
      map("grr", function()
        vim.lsp.buf.references({ includeDeclaration = false }, { on_list = on_list })
      end)
    end

    if client:supports_method "textDocument/implementation" then
      map("gI", function()
        vim.lsp.buf.implementation { on_list = on_list }
      end)
    end

    if client:supports_method "textDocument/documentSymbol" then
      map("gs", function()
        vim.lsp.buf.document_symbol { on_list = on_list }
      end)
    end

    if client:supports_method "textDocument/codeLens" then
      map("grl", function()
        vim.lsp.codelens.run()
      end)
      map("grL", function()
        vim.lsp.codelens.enable(not vim.lsp.codelens.is_enabled { bufnr = bufnr }, { bufnr = bufnr })
      end)
    end

    if client:supports_method "textDocument/inlayHint" then
      map("gri", function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = bufnr }, { bufnr = bufnr })
      end)
    end

    if client:supports_method "textDocument/documentHighlight" then
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
    end

    if client:supports_method "textDocument/linkedEditingRange" then
      vim.lsp.linked_editing_range.enable(true, { client_id = client.id })
    end

    if client:supports_method "textDocument/documentColor" then
      vim.b[bufnr].minihipatterns_disable = true
      vim.lsp.document_color.enable(true, { bufnr = bufnr })
    end

    if client:supports_method "textDocument/selectionRange" then
      map("<C-Space>", function()
        vim.lsp.buf.selection_range(1)
      end, { "n", "x" })
      map("<C-S-Space>", function()
        vim.lsp.buf.selection_range(-1)
      end, "x")
    end

    if client:supports_method "textDocument/formatting" then
      if not vim.b[bufnr].formatter then
        vim.b[bufnr].formatter = vim.lsp.buf.format
      end
    end

    -- if client:supports_method "textDocument/onTypeFormatting" then
    --   vim.lsp.on_type_formatting.enable(true, { client_id = client.id })
    -- end

    if client:supports_method "textDocument/completion" then
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
      map("<C-Space>", function()
        vim.lsp.completion.get()
      end, "i")
      map("<CR>", function()
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
      end, "i")
      map("<Tab>", function()
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
      end, { "i", "s" })
      map("<S-Tab>", function()
        if vim.fn.pumvisible() == 1 then
          should_confirm = true
          feedkeys "<C-p>"
        else
          feedkeys "<S-Tab>"
        end
      end, { "i", "s" })
    end

    if client:supports_method "textDocument/inlineCompletion" then
      map("<C-.>", function()
        if vim.lsp.inline_completion.is_enabled { bufnr = bufnr } then
          vim.lsp.inline_completion.enable(false, { bufnr = bufnr })
        else
          feedkeys "<C-e>"
          vim.lsp.inline_completion.enable(true, { bufnr = bufnr })
          vim.lsp.inline_completion.select { bufnr = bufnr, count = 0 }
        end
      end, "i")
      map("<C-S-.>", function()
        if vim.lsp.inline_completion.is_enabled { bufnr = bufnr } then
          vim.lsp.inline_completion.get { bufnr = bufnr }
          vim.lsp.inline_completion.enable(false, { bufnr = bufnr })
        end
      end, "i")
    end
  end,
})
