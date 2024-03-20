---@diagnostic disable-next-line:param-type-mismatch
if vim.api.nvim_buf_get_name(0):find(vim.fn.stdpath "config") then
  require("user.config-lsp").start()
end
