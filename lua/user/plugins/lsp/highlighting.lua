local M = {}

local LspDocumentHighlight = vim.api.nvim_create_augroup("LspDocumentHighlight", { clear = false })

function M.setup(client, bufnr)
  if client.server_capabilities.documentHighlightProvider then
    vim.api.nvim_clear_autocmds {
      group = LspDocumentHighlight,
      buffer = bufnr,
    }
    vim.api.nvim_create_autocmd("CursorHold", {
      group = LspDocumentHighlight,
      buffer = bufnr,
      callback = function()
        vim.lsp.buf.document_highlight()
      end,
    })
    vim.api.nvim_create_autocmd("CursorMoved", {
      group = LspDocumentHighlight,
      buffer = bufnr,
      callback = function()
        vim.lsp.buf.clear_references(bufnr)
      end,
    })
  end
end

return M
