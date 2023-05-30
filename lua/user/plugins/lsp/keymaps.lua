local M = {}

function M.setup(bufnr)
  local function map(lhs, rhs, desc)
    local opts = {
      buffer = bufnr,
    }
    if desc then
      opts.desc = desc
    end
    vim.keymap.set("n", lhs, rhs, opts)
  end

  map("<Leader>lc", vim.lsp.buf.code_action, "Code Action")
  map("<Leader>lf", vim.lsp.buf.format, "Format")
  map("<Leader>lr", vim.lsp.buf.rename, "Rename")
  map("<Leader>ll", vim.lsp.codelens.run, "Codelens")
  map("<Leader>lj", vim.diagnostic.goto_next, "Next Diagnostic")
  map("<Leader>lk", vim.diagnostic.goto_prev, "Prev Diagnostic")
  map("<Leader>lR", "<Cmd>LspRestart<CR>", "Restart")
  map("<Leader>ld", "<Cmd>Telescope lsp_document_symbols<CR>", "Symbols")
  map("K", vim.lsp.buf.hover, "Hover")
  map("gd", vim.lsp.buf.definition, "Definition")
  map("gD", require("user.plugins.lsp.definition").open, "Definition split")
  map("gr", "<Cmd>Telescope lsp_references<CR>", "References")
end

return M
