return {
  "Wansmer/treesj",
  cmd = { "TSJJoin", "TSJSplit", "TSJToggle" },
  opts = function()
    return {
      use_default_keymaps = false,
      langs = {
        smarty = require("treesj.langs.utils").merge_preset(require "treesj.langs.html", {}),
      },
    }
  end,
  init = function()
    require("user.utils").keymaps {
      n = {
        g = {
          J = { "<Cmd>TSJJoin<CR>", "Join Lines" },
          S = { "<Cmd>TSJSplit<CR>", "Split Lines" },
        },
      },
    }
  end,
}
