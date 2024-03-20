vim.api.nvim_buf_create_user_command(0, "X", function()
  vim.cmd.write()
  vim.cmd { cmd = "!", args = { "php", "%" } }
end, {
  bang = false,
  nargs = 0,
  desc = "Save and source",
})

vim.opt_local.tabstop = 4
vim.opt_local.shiftwidth = 4
