return {
  "Wansmer/treesj",
  cmd = { "TSJJoin", "TSJSplit", "TSJToggle" },
  keys = {
    { "gJ", "<Cmd>TSJJoin<CR>", desc = "Join Lines" },
    { "gS", "<Cmd>TSJSplit<CR>", desc = "Split Lines" },
  },
  opts = function()
    return {
      use_default_keymaps = false,
      langs = {
        smarty = require("treesj.langs.utils").merge_preset(require "treesj.langs.html", {}),
      },
    }
  end,
}
