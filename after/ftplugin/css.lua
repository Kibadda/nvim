if vim.env.LOCATION == "work" then
  vim.opt_local.tabstop = 4
  vim.opt_local.shiftwidth = 4
else
  vim.opt_local.tabstop = 2
  vim.opt_local.shiftwidth = 2
end
