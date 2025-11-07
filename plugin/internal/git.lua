if vim.g.loaded_plugin_git then
  return
end

vim.g.loaded_plugin_git = 1

vim.api.nvim_create_user_command("Git", function(data)
  require("me.git").run(data)
end, {
  bang = false,
  bar = false,
  nargs = "*",
  complete = function(_, cmdline, _)
    return require("me.git").complete(cmdline)
  end,
})
