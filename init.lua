_ = {
  [======================================[
   _  __ _  _               _     _
  | |/ /(_)| |__   __ _  __| | __| | __ _
  | ' / | || ´_ \ / _` |/ _` |/ _` |/ _` |
  | . \ | || |_) | (_| | (_| | (_| | (_| |
  |_|\_\|_||_⹁__/ \__,_|\__,_|\__,_|\__,_|

  ]======================================],
}

require "user.options"
require "user.filetypes"

require("user.utils.globals").set("", {
  mapleader = " ",
  formatoptions = "nljqrc",
})

require "user.lazy"

require "user.keymaps"
require "user.autocmds"
require "user.commands"
