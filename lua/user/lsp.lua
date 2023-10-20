local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup
local clear = vim.api.nvim_clear_autocmds

vim.g.LspAutoFormat = vim.g.LspAutoFormat or 0
vim.g.LspInlayHints = vim.g.LspInlayHints or 0

local lsp_start = vim.lsp.start
---@diagnostic disable-next-line:duplicate-set-field
vim.lsp.start = function(config, start_opts)
  if not config.capabilities then
    config.capabilities = vim.lsp.protocol.make_client_capabilities()
  end

  if config.root_markers then
    config.root_dir = vim.fs.dirname(vim.fs.find(config.root_markers, { upward = true })[1])
    config.root_markers = nil
  end

  return lsp_start(config, start_opts)
end

vim.api.nvim_set_hl(0, "LspInlayHint", { fg = "#E8D4B0", italic = true })

autocmd("LspAttach", {
  group = augroup("LspAttach", { clear = true }),
  callback = function(args)
    local bufnr = args.buf
    local client = vim.lsp.get_client_by_id(args.data.client_id)

    if not client then
      return
    end

    local function map(mode, lhs, rhs, desc)
      vim.keymap.set(mode, lhs, rhs, { desc = desc, buffer = bufnr })
    end

    local groups = {
      highlight = augroup("LspAttachHighlight", { clear = false }),
      format = augroup("LspAttachFormat", { clear = false }),
      codelens = augroup("LspAttachCodelens", { clear = false }),
      inlay = augroup("LspAttachInlay", { clear = false }),
    }

    if client.server_capabilities.documentHighlightProvider then
      clear { group = groups.highlight, buffer = bufnr }
      autocmd("CursorHold", {
        group = groups.highlight,
        buffer = bufnr,
        callback = vim.lsp.buf.document_highlight,
      })
      autocmd("CursorMoved", {
        group = groups.highlight,
        buffer = bufnr,
        callback = vim.lsp.buf.clear_references,
      })
    end

    if client.server_capabilities.hoverProvider then
      map("n", "K", vim.lsp.buf.hover, "Hover")
    end

    if client.server_capabilities.codeActionProvider then
      map("n", "<Leader>lc", vim.lsp.buf.code_action, "Code Action")
    end

    if client.server_capabilities.signatureHelpProvider then
      map("i", "<C-k>", vim.lsp.buf.signature_help, "Signature Help")
    end

    local format = nil
    if #require("conform").list_formatters(bufnr) > 0 then
      format = require("conform").format
    elseif client.server_capabilities.documentFormattingProvider then
      format = vim.lsp.buf.format
    end

    if format then
      map("n", "<Leader>lf", format, "Format")

      map("n", "<Leader>lt", function()
        vim.g.LspAutoFormat = vim.g.LspAutoFormat == 0 and 1 or 0
        vim.cmd.redrawstatus()
      end, "Toggle Auto Format")

      clear { group = groups.format, buffer = bufnr }
      autocmd("BufWritePre", {
        group = groups.format,
        buffer = bufnr,
        callback = function()
          if vim.g.LspAutoFormat == 1 then
            format()
          end
        end,
      })
    end

    if client.server_capabilities.renameProvider then
      map("n", "<Leader>lr", vim.lsp.buf.rename, "Rename")
    end

    if client.server_capabilities.codeLensProvider then
      map("n", "<Leader>ll", vim.lsp.codelens.run, "Codelens")

      clear { group = groups.codelens, buffer = bufnr }
      autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
        group = groups.codelens,
        buffer = bufnr,
        callback = vim.lsp.codelens.refresh,
      })
    end

    if client.server_capabilities.definitionProvider then
      map("n", "gd", vim.lsp.buf.definition, "Go to Definition")
    end

    if client.server_capabilities.referencesProvider then
      map("n", "gr", function()
        local ok, builtin = pcall(require, "telescope.builtin")
        if ok then
          builtin.lsp_references()
        else
          vim.lsp.buf.references()
        end
      end, "References")
    end

    if client.server_capabilities.documentSymbolProvider then
      map("n", "<Leader>ls", function()
        local ok, builtin = pcall(require, "telescope.builtin")
        if ok then
          builtin.lsp_document_symbols()
        else
          vim.lsp.buf.document_symbol()
        end
      end, "Symbols")
    end

    if client.server_capabilities.inlayHintProvider then
      map("n", "<Leader>li", function()
        vim.g.LspInlayHints = vim.g.LspInlayHints == 0 and 1 or 0
        vim.lsp.inlay_hint(bufnr, vim.g.LspInlayHints == 1)
        vim.cmd.redrawstatus()
      end, "Toggle Inlay Hint")

      clear { group = groups.inlay, buffer = bufnr }
      autocmd("BufEnter", {
        group = groups.inlay,
        callback = function()
          vim.lsp.inlay_hint(bufnr, vim.g.LspInlayHints == 1)
        end,
      })

      vim.lsp.inlay_hint(bufnr, vim.g.LspInlayHints == 1)
    end

    map("n", "<Leader>lj", vim.diagnostic.goto_next, "Next Diagnostic")
    map("n", "<Leader>lk", vim.diagnostic.goto_prev, "Prev Diagnostic")

    -- map("n", "<Leader>lR", function()
    --   client.stop()

    --   vim.defer_fn(function()
    --     vim.lsp.start(client.config)
    --   end, 500)
    -- end, { desc = "Restart", buffer = bufnr })
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
      severity_limit = "Error",
    },
    underline = {
      severity_limit = "Warning",
    },
    virtual_text = true,
  })

vim.diagnostic.config {
  severity_sort = true,
  float = {
    border = "single",
  },
}

-- local ok, wf = pcall(require, "vim.lsp._watchfiles")
-- if ok then
--   -- disable lsp watcher. Too slow on linux
--   wf._watchfunc = function()
--     return function() end
--   end
-- end
