-- --  _  __ _  _               _     _
-- -- | |/ /(_)| |__   __ _  __| | __| | __ _
-- -- | ' / | || ´_ \ / _` |/ _` |/ _` |/ _` |
-- -- | . \ | || |_) | (_| | (_| | (_| | (_| |
-- -- |_|\_\|_||_⹁__/ \__,_|\__,_|\__,_|\__,_|

vim.g.mapleader = vim.keycode "<Space>"

require "me.monkeypatching"
require "me.disable"

vim.pack.add {
  "https://github.com/nvim-tree/nvim-web-devicons",
  "https://github.com/ku1ik/vim-pasta",
}

-- require("vim._extui").enable {}

-- nvim-surround
-- nvim-autopairs
-- mini.pick (hunks, stashes)

-- breadcrumbs plugin
-- move my own plugins into config?

vim.keymap.set("n", "<Leader>a", function()
  require("me.git.lsp").attach()
end)
