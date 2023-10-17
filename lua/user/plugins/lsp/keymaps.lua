local M = {}

---@param client lsp.Client
function M.setup(client, bufnr)
  local function map(mode, lhs, rhs, desc)
    local opts = {
      buffer = bufnr,
    }
    if desc then
      opts.desc = desc
    end
    vim.keymap.set(mode, lhs, rhs, opts)
  end

  if client.server_capabilities.hoverProvider then
    map("n", "K", vim.lsp.buf.hover, "Hover")
  end

  if client.server_capabilities.codeActionProvider then
    map("n", "<Leader>lc", vim.lsp.buf.code_action, "Code Action")
  end

  map("i", "<C-k>", vim.lsp.buf.signature_help, "Signature Help")
  map("n", "<Leader>lf", vim.lsp.buf.format, "Format")
  map("n", "<Leader>lr", vim.lsp.buf.rename, "Rename")
  map("n", "<Leader>ll", vim.lsp.codelens.run, "Codelens")
  map("n", "<Leader>lj", vim.diagnostic.goto_next, "Next Diagnostic")
  map("n", "<Leader>lk", vim.diagnostic.goto_prev, "Prev Diagnostic")
  map("n", "<Leader>lR", "<Cmd>LspRestart<CR>", "Restart")
  map("n", "<Leader>ls", "<Cmd>Telescope lsp_document_symbols<CR>", "Symbols")
  map("n", "gd", vim.lsp.buf.definition, "Definition")
  map("n", "gD", require("user.plugins.lsp.definition").open, "Definition split")
  map("n", "gr", "<Cmd>Telescope lsp_references<CR>", "References")
end

return M
