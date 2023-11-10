vim.opt_local.tabstop = 4
vim.opt_local.shiftwidth = 4
vim.opt_local.relativenumber = true
vim.opt_local.number = true

if vim.g.started_as_db_client then
  vim.opt_local.statuscolumn = "%{%v:lua.require'heirline'.eval_statuscolumn()%}"
end
