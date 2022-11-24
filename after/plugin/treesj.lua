if not plugins_ok "treesj" then
  return
end

require("treesj").setup {
  use_default_keymaps = false,
  langs = {
    smarty = require("treesj.langs.utils").merge_preset(require "treesj.langs.html", {}),
  },
}

require("user.utils.register").keymaps {
  mode = "n",
  prefix = "",
  {
    gJ = { "<Cmd>TSJJoin<CR>", "Join Lines" },
    gS = { "<Cmd>TSJSplit<CR>", "Split Lines" },
  },
}
