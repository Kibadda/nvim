if vim.g.loaded_plugin_ai then
  return
end

vim.g.loaded_plugin_ai = 1

vim.api.nvim_create_user_command("AI", function(args)
  require("me.ai").run(args)
end, {
  range = true,
  nargs = "?",
  desc = "AI",
  complete = function(_, cmdline, _)
    return require("me.ai").complete(cmdline)
  end,
})

vim.keymap.set("n", "<C-.>", function()
  require("me.ai").run { args = "" }
end)
