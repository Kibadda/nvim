local M = {
  "dvoytik/hi-my-words.nvim",
  cmd = { "HiMyWordsToggle", "HiMyWordsClear" },
}

function M.config()
  require "hi-my-words"
end

return M
