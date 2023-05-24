local params = {
  textDocument = {
    uri = vim.uri_from_bufnr(0),
  },
  range = {
    start = { line = 0, character = 0 },
    ["end"] = { line = vim.api.nvim_buf_line_count(0), character = 0 },
  },
}
vim.lsp.buf_request(0, "textDocument/inlayHint", params, function(err, result, ctx)
  vim.print(err)
  vim.print(result)
  vim.print(ctx)
end)
