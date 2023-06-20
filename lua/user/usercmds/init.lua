local usercmd = vim.api.nvim_create_user_command
local functions = require "user.usercmds.functions"

usercmd("D", functions.buf_delete, {
  bang = true,
  nargs = 0,
  desc = "Bdelete",
})

usercmd("X", functions.source, {
  bang = false,
  nargs = 0,
  desc = "Save and source",
})

usercmd("OpenGitInBrowser", functions.open_git_in_browser, {
  bang = false,
  nargs = 0,
  desc = "Open current git project in browser",
})

usercmd("Weather", functions.show_weather, {
  bang = false,
  nargs = 0,
  desc = "Show information",
})

usercmd("ScratchList", functions.show_scratchlist, {
  bang = false,
  nargs = 0,
  desc = "Open plugin list",
})

usercmd("PluginList", functions.show_pluginlist, {
  bang = false,
  nargs = 0,
  desc = "Open plugin list",
})

usercmd("PluginOpen", functions.open_plugin, {
  bang = false,
  nargs = 0,
  desc = "Open plugin in browser",
})
