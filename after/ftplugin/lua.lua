require("user.utils.options").set {
  formatoptions = require("user.utils.globals").get("", "formatoptions"),
}

if vim.fn.fnamemodify(vim.fn.expandcmd "%", ":t") == "plugins.lua" then
  require("user.utils.register").keymaps {
    mode = "n",
    prefix = "",
    buffer = 0,
    {
      gX = { require("user.open_plugin").in_browser, "Open plugin in Browser" },
      gF = { require("user.open_plugin").in_file, "Open plugin file" },
    },
  }
end
