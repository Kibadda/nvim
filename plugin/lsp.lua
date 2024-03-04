if vim.g.loaded_lsp then
  return
end

vim.g.loaded_lsp = 1

local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup
local clear = vim.api.nvim_clear_autocmds

vim.g.LspInlayHints = vim.g.LspInlayHints or 0

local lsp_start = vim.lsp.start
---@param config vim.lsp.ClientConfig
---@param start_opts? vim.lsp.start.Opts
---@diagnostic disable-next-line:duplicate-set-field
function vim.lsp.start(config, start_opts)
  -- require mason to load binary path
  require "mason"

  config.capabilities = vim.tbl_deep_extend("force", vim.lsp.protocol.make_client_capabilities(), {
    workspace = { didChangeWatchedFiles = { dynamicRegistration = false } },
  }, config.capabilities or {})

  if config.root_markers then
    config.root_dir =
      vim.fs.dirname(vim.fs.find(config.root_markers, { upward = true, path = vim.api.nvim_buf_get_name(0) })[1])
    ---@diagnostic disable-next-line:inject-field
    config.root_markers = nil
  end

  return lsp_start(config, start_opts)
end

local on_codelens = vim.lsp.codelens.on_codelens
---@diagnostic disable-next-line:duplicate-set-field
function vim.lsp.codelens.on_codelens(err, result, ctx, _)
  if vim.b[ctx.bufnr].codelenses then
    result = vim.b[ctx.bufnr].codelenses(err, result, ctx)
  end

  on_codelens(err, result, ctx, _)
end

local group = augroup("LspAttach", { clear = true })

autocmd("LspAttach", {
  group = group,
  callback = function(args)
    local bufnr = args.buf
    local client = vim.lsp.get_client_by_id(args.data.client_id)

    if not client then
      return
    end

    ---@param lhs string
    ---@param rhs string|function
    ---@param desc string
    ---@param mode? string
    local function map(lhs, rhs, desc, mode)
      vim.keymap.set(mode or "n", lhs, rhs, { desc = desc, buffer = bufnr })
    end

    local groups = {
      highlight = augroup("LspAttachHighlight", { clear = false }),
      codelens = augroup("LspAttachCodelens", { clear = false }),
      inlay = augroup("LspAttachInlay", { clear = false }),
    }

    local methods = vim.lsp.protocol.Methods

    if client.supports_method(methods.textDocument_documentHighlight) then
      clear { group = groups.highlight, buffer = bufnr }
      autocmd({ "CursorHold", "InsertLeave", "BufEnter" }, {
        group = groups.highlight,
        buffer = bufnr,
        callback = vim.lsp.buf.document_highlight,
      })
      autocmd({ "CursorMoved", "InsertEnter", "BufLeave" }, {
        group = groups.highlight,
        buffer = bufnr,
        callback = vim.lsp.buf.clear_references,
      })
    end

    if client.supports_method(methods.textDocument_codeAction) then
      map("<Leader>lc", vim.lsp.buf.code_action, "Code Action")
    end

    if client.supports_method(methods.textDocument_signatureHelp) then
      map("<C-k>", vim.lsp.buf.signature_help, "Signature Help", "i")
    end

    if client.supports_method(methods.textDocument_formatting) and not vim.b[bufnr].formatter then
      vim.b[bufnr].formatter = vim.lsp.buf.format
    end

    if client.supports_method(methods.textDocument_rename) then
      map("<Leader>lr", vim.lsp.buf.rename, "Rename")
    end

    if client.supports_method(methods.textDocument_codeLens) then
      map("<Leader>ll", vim.lsp.codelens.run, "Codelens")

      clear { group = groups.codelens, buffer = bufnr }
      autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
        group = groups.codelens,
        buffer = bufnr,
        callback = vim.lsp.codelens.refresh,
      })
    end

    if client.supports_method(methods.textDocument_definition) then
      map("gd", vim.lsp.buf.definition, "Go to Definition")
    end

    if client.supports_method(methods.textDocument_references) then
      map("gr", function()
        local ok, extra = pcall(require, "mini.extra")
        if ok then
          extra.pickers.lsp { scope = "references" }
        else
          vim.lsp.buf.references()
        end
      end, "References")
    end

    if client.supports_method(methods.textDocument_implementation) then
      map("gI", function()
        local ok, extra = pcall(require, "mini.extra")
        if ok then
          extra.pickers.lsp { scope = "implementation" }
        else
          vim.lsp.buf.implementation()
        end
      end, "Implementations")
    end

    if client.supports_method(methods.textDocument_documentSymbol) then
      map("<Leader>ls", function()
        local ok, extra = pcall(require, "mini.extra")
        if ok then
          extra.pickers.lsp { scope = "document_symbol" }
        else
          vim.lsp.buf.document_symbol()
        end
      end, "Symbols")
    end

    if client.supports_method(methods.textDocument_inlayHint) then
      map("<Leader>li", function()
        vim.g.LspInlayHints = vim.g.LspInlayHints == 0 and 1 or 0
        vim.lsp.inlay_hint.enable(bufnr, vim.g.LspInlayHints == 1)
        vim.cmd.redrawstatus()
      end, "Toggle Inlay Hint")

      clear { group = groups.inlay, buffer = bufnr }
      autocmd("BufEnter", {
        group = groups.inlay,
        callback = function()
          vim.lsp.inlay_hint.enable(bufnr, vim.g.LspInlayHints == 1)
        end,
      })

      vim.lsp.inlay_hint.enable(bufnr, vim.g.LspInlayHints == 1)
    end

    map("<Leader>lj", vim.diagnostic.goto_next, "Next Diagnostic")
    map("<Leader>lk", vim.diagnostic.goto_prev, "Prev Diagnostic")

    -- what to do with more than one client per buffer
    map("<Leader>lC", function()
      local bufs = vim.lsp.get_buffers_by_client_id(client.id)

      client.stop()

      vim.wait(30000, function()
        return vim.lsp.get_client_by_id(client.id) == nil
      end)

      local client_id = vim.lsp.start_client(client.config)

      if client_id then
        for _, buf in ipairs(bufs) do
          vim.lsp.buf_attach_client(buf, client_id)
        end
      end
    end, "Restart")
  end,
})

---@type table<integer, { win: integer, buf: integer, row: integer, client: lsp.Client?}>
local progress_windows = {}

local function show_progress(win, buf, data)
  local ttext = {}

  if data.result.token and progress_windows[data.result.token] and progress_windows[data.result.token].client then
    table.insert(ttext, progress_windows[data.result.token].client.name .. ":")
  end

  if data.result.value.title then
    table.insert(ttext, data.result.value.title)
  end

  if data.result.value.percentage and data.result.value.percentage > 0 then
    table.insert(ttext, ("(%s%%)"):format(data.result.value.percentage))
  end

  if data.result.value.message then
    table.insert(ttext, data.result.value.message)
  end

  local text = table.concat(ttext, " ")

  local text_width = string.len(text) + 4

  local col = vim.o.columns - text_width

  local row
  if progress_windows[data.result.token] then
    row = progress_windows[data.result.token].row
  else
    row = vim.o.lines - 3 - vim.tbl_count(progress_windows)
  end

  local win_options = {
    relative = "editor",
    height = 1,
    row = row,
    col = col,
    width = text_width,
  }

  if not win or not vim.api.nvim_win_is_valid(win) then
    win = vim.api.nvim_open_win(buf, false, win_options)

    progress_windows[data.result.token] = {
      win = win,
      buf = buf,
      row = row,
      client = vim.lsp.get_client_by_id(data.client_id),
    }
  else
    vim.api.nvim_win_set_config(win, win_options)
  end

  vim.api.nvim_buf_set_lines(buf, 0, -1, false, { text })
end

autocmd("LspProgress", {
  group = group,
  callback = function(args)
    local token = args.data.result.token

    if args.file == "begin" then
      show_progress(nil, vim.api.nvim_create_buf(false, true), args.data)
    elseif args.file == "report" then
      if progress_windows[token] then
        show_progress(progress_windows[token].win, progress_windows[token].buf, args.data)
      end
    elseif args.file == "end" then
      if progress_windows[token] then
        vim.api.nvim_win_close(progress_windows[token].win, false)
        local row = progress_windows[token].row
        progress_windows[token] = nil
        for _, r in pairs(progress_windows) do
          if r.row < row then
            r.row = r.row + 1
          end
        end
      end
    end
  end,
})

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
  border = "single",
  title = " Documentation ",
})

vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers["textDocument/signatureHelp"], {
  border = "single",
  title = " Signature ",
})

vim.lsp.handlers["textDocument/publishDiagnostics"] =
  vim.lsp.with(vim.lsp.handlers["textDocument/publishDiagnostics"], {
    signs = {
      severity = { min = vim.diagnostic.severity.ERROR },
    },
    underline = {
      severity = { min = vim.diagnostic.severity.WARN },
    },
    virtual_text = true,
  })

vim.diagnostic.config {
  severity_sort = true,
  float = {
    border = "single",
  },
}
