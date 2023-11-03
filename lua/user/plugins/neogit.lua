return {
  "NeogitOrg/neogit",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  cmd = "Neogit",
  keys = {
    { "<Leader>G", "<Cmd>Neogit<CR>", desc = "Open Neogit" },
  },
  init = function()
    vim.cmd.cabbrev "G Neogit"
  end,
  opts = {},
}
