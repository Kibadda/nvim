if vim.g.loaded_plugin_session then
  return
end

vim.g.loaded_plugin_session = 1

vim.api.nvim_create_autocmd("VimLeavePre", {
  group = vim.api.nvim_create_augroup("Session", { clear = true }),
  callback = function()
    require("me.session").update()
  end,
})

vim.keymap.set("n", "<Leader>Ss", function()
  vim.cmd.restart()
end)
vim.keymap.set("n", "<Leader>Sn", function()
  require("me.session").new()
end)
vim.keymap.set("n", "<Leader>Sd", function()
  require("me.session").delete()
end)
vim.keymap.set("n", "<Leader>Sl", function()
  require("me.session").load()
end)
