return function()
  local params = { textDocument = vim.lsp.util.make_text_document_params() }
  vim.lsp.buf_request(0, vim.lsp.protocol.Methods.textDocument_documentSymbol, params, function(err, result, _, _)
    if err then
      return
    end

    if result then
      local results = vim.lsp.util.symbols_to_items(result)

      for _, item in ipairs(results) do
        item.path = vim.fn.fnamemodify(item.filename, ":.")
      end

      MiniPick.start {
        source = {
          name = "LSP Document Symbols",
          items = results,
          show = function(buf_id, items, query)
            MiniPick.default_show(buf_id, items, query, { show_icons = true })
          end,
        },
      }
    end
  end)
end
