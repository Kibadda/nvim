local M = {}

vim.g.InlayHints = vim.g.InlayHints or 0

local LspInlayHint = vim.api.nvim_create_augroup("LspInlayHint", { clear = true })

function M.toggle(bufnr)
  vim.g.InlayHints = vim.g.InlayHints == 0 and 1 or 0
  vim.lsp.inlay_hint(bufnr, vim.g.InlayHints == 1)
end

function M.setup(bufnr)
  vim.api.nvim_set_hl(0, "LspInlayHint", { fg = "#E8D4B0", italic = true })

  vim.keymap.set("n", "<Leader>li", function()
    M.toggle(bufnr)
  end, { desc = "Toggle Inlay Hints", buffer = bufnr })

  vim.api.nvim_clear_autocmds {
    buffer = bufnr,
    group = LspInlayHint,
  }
  vim.api.nvim_create_autocmd("BufEnter", {
    group = LspInlayHint,
    buffer = bufnr,
    callback = function()
      vim.lsp.inlay_hint(bufnr, vim.g.InlayHints == 1)
    end,
  })

  if vim.g.InlayHints == 1 then
    vim.lsp.inlay_hint(bufnr, true)
  end
end

return M
