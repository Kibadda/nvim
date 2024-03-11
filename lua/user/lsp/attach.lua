vim.g.LspInlayHints = vim.g.LspInlayHints or 0

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("LspAttach", { clear = true }),
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
      highlight = vim.api.nvim_create_augroup("LspAttachHighlight", { clear = false }),
      codelens = vim.api.nvim_create_augroup("LspAttachCodelens", { clear = false }),
      inlay = vim.api.nvim_create_augroup("LspAttachInlay", { clear = false }),
    }

    local methods = vim.lsp.protocol.Methods

    if client.supports_method(methods.textDocument_documentHighlight) then
      vim.api.nvim_clear_autocmds { group = groups.highlight, buffer = bufnr }
      vim.api.nvim_create_autocmd({ "CursorHold", "InsertLeave", "BufEnter" }, {
        group = groups.highlight,
        buffer = bufnr,
        callback = vim.lsp.buf.document_highlight,
      })
      vim.api.nvim_create_autocmd({ "CursorMoved", "InsertEnter", "BufLeave" }, {
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

      vim.api.nvim_clear_autocmds { group = groups.codelens, buffer = bufnr }
      vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
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

    if client.supports_method(methods.workspace_symbol) then
      map("<Leader>lS", function()
        local ok, extra = pcall(require, "mini.extra")
        if ok then
          extra.pickers.lsp { scope = "workspace_symbol" }
        else
          vim.lsp.buf.workspace_symbol()
        end
      end, "Workspace Symbols")
    end

    if client.supports_method(methods.textDocument_inlayHint) then
      map("<Leader>li", function()
        vim.g.LspInlayHints = vim.g.LspInlayHints == 0 and 1 or 0
        vim.lsp.inlay_hint.enable(bufnr, vim.g.LspInlayHints == 1)
        vim.cmd.redrawstatus()
      end, "Toggle Inlay Hint")

      vim.api.nvim_clear_autocmds { group = groups.inlay, buffer = bufnr }
      vim.api.nvim_create_autocmd("BufEnter", {
        group = groups.inlay,
        callback = function()
          vim.lsp.inlay_hint.enable(bufnr, vim.g.LspInlayHints == 1)
        end,
      })

      vim.lsp.inlay_hint.enable(bufnr, vim.g.LspInlayHints == 1)
    end

    map("<Leader>lj", vim.diagnostic.goto_next, "Next Diagnostic")
    map("<Leader>lk", vim.diagnostic.goto_prev, "Prev Diagnostic")

    map("<Leader>lC", function()
      for _, c in ipairs(vim.lsp.get_clients { bufnr = bufnr }) do
        local bufs = vim.lsp.get_buffers_by_client_id(c.id)

        c.stop()

        vim.wait(30000, function()
          return vim.lsp.get_client_by_id(c.id) == nil
        end)

        local client_id = vim.lsp.start_client(c.config)

        if client_id then
          for _, buf in ipairs(bufs) do
            vim.lsp.buf_attach_client(buf, client_id)
          end
        end
      end
    end, "Restart")
  end,
})
