_ = {
  [======================================[
   _  __ _  _               _     _
  | |/ /(_)| |__   __ _  __| | __| | __ _
  | ' / | || ´_ \ / _` |/ _` |/ _` |/ _` |
  | . \ | || |_) | (_| | (_| | (_| | (_| |
  |_|\_\|_||_⹁__/ \__,_|\__,_|\__,_|\__,_|

  ]======================================],
}

vim.g.mapleader = vim.keycode "<Space>"

require "user.options"
require "user.filetypes"

require "user.lazy"

require "user.keymaps"
require "user.autocmds"
require "user.usercmds"
