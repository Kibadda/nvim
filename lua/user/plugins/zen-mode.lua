return {
  "folke/zen-mode.nvim",
  cmd = "ZenMode",
  opts = {
    window = {
      backdrop = 0.95,
      height = 0.9,
      width = 140,
      options = {
        -- number = false,
        -- relativenumber = false,
        -- signcolumn = "no",
        statuscolumn = nil,
      },
    },
    plugins = {
      kitty = { enabled = true, font = "+0" },
      tmux = { enabled = true },
      gitsigns = { enabled = true },
    },
  },
}
