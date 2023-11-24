if vim.g.loaded_usercmds then
  return
end

vim.g.loaded_usercmds = 1

vim.api.nvim_create_user_command("D", function(args)
  vim.cmd.BufferLineCyclePrev()
  vim.cmd.split()
  vim.cmd.BufferLineCycleNext()
  vim.cmd.bdelete { bang = args.bang }
  vim.cmd.redrawt()
end, {
  bang = true,
  nargs = 0,
  desc = "Bdelete",
})
