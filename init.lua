_ = {
  [======================================[
   _  __ _  _               _     _
  | |/ /(_)| |__   __ _  __| | __| | __ _
  | ' / | || ´_ \ / _` |/ _` |/ _` |/ _` |
  | . \ | || |_) | (_| | (_| | (_| | (_| |
  |_|\_\|_||_⹁__/ \__,_|\__,_|\__,_|\__,_|

  ]======================================],
}

require "user.config"

require "user.options"
require "user.filetypes"

require "user.lazy"

require("user.themes").apply "tundra"

require "user.keymaps"
require "user.autocmds"
require "user.usercmds"

require "user.lsp"
