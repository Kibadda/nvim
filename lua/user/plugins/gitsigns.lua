return {
  "lewis6991/gitsigns.nvim",
  event = "VeryLazy",
  keys = function()
    return {
      { "<Leader>gj", "<Cmd>Gitsigns next_hunk<CR>", desc = "Next Hunk" },
      { "<Leader>gk", "<Cmd>Gitsigns prev_hunk<CR>", desc = "Prev Hunk" },
      { "<Leader>gr", "<Cmd>Gitsigns reset_hunk<CR>", desc = "Reset Hunk" },
      { "<Leader>gR", "<Cmd>Gitsigns reset_buffer<CR>", desc = "Reset Buffer" },
      { "ih", ":<C-u>Gitsigns select_hunk<CR>", desc = "Hunk", mode = { "o", "x" } },
      { "ah", ":<C-u>Gitsigns select_hunk<CR>", desc = "Hunk", mode = { "o", "x" } },
    }
  end,
  opts = {
    attach_to_untracked = true,
  },
}
