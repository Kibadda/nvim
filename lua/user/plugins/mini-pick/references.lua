return function()
  local params = vim.lsp.util.make_position_params()
  params.context = {
    includeDeclaration = true,
  }
  local filepath = vim.api.nvim_buf_get_name(0)
  local lnum = vim.api.nvim_win_get_cursor(0)[1]
  vim.lsp.buf_request(0, vim.lsp.protocol.Methods.textDocument_references, params, function(err, result, ctx, _)
    if err then
      return
    end

    if result then
      local results = vim.lsp.util.locations_to_items(result, vim.lsp.get_client_by_id(ctx.client_id).offset_encoding)

      results = vim.tbl_filter(function(v)
        return not (v.filename == filepath and v.lnum == lnum)
      end, results)

      for _, item in ipairs(results) do
        item.path = vim.fn.fnamemodify(item.filename, ":.")
        item.text = item.path
      end

      MiniPick.start {
        source = {
          name = "LSP References",
          items = results,
          show = function(buf_id, items, query)
            MiniPick.default_show(buf_id, items, query, { show_icons = true })
          end,
        },
      }
    end
  end)
end
