--  _  __ _  _               _     _
-- | |/ /(_)| |__   __ _  __| | __| | __ _
-- | ' / | || ´_ \ / _` |/ _` |/ _` |/ _` |
-- | . \ | || |_) | (_| | (_| | (_| | (_| |
-- |_|\_\|_||_⹁__/ \__,_|\__,_|\__,_|\__,_|

vim.g.mapleader = vim.keycode "<Space>"

require "me.monkeypatching"
require "me.disable"

vim.pack.add {
  "https://github.com/nvim-tree/nvim-web-devicons",
  "https://github.com/ku1ik/vim-pasta",
}

require("vim._core.ui2").enable {
  enable = true,
  msg = {
    target = "cmd",
    timeout = 4000,
  },
}
