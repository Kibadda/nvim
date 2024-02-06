return {
  "lewis6991/gitsigns.nvim",
  dependencies = {
    "nvim-treesitter/nvim-treesitter-textobjects",
  },
  event = "VeryLazy",
  keys = function()
    local ts = require "nvim-treesitter.textobjects.repeatable_move"
    local next_hunk_repeat, prev_hunk_repeat = ts.make_repeatable_move_pair(function()
      require("gitsigns").next_hunk()
    end, function()
      require("gitsigns").prev_hunk()
    end)

    return {
      { "<Leader>gj", "<Cmd>Gitsigns next_hunk<CR>", desc = "Next Hunk" },
      { "<Leader>gk", "<Cmd>Gitsigns prev_hunk<CR>", desc = "Prev Hunk" },
      { "<Leader>gr", "<Cmd>Gitsigns reset_hunk<CR>", desc = "Reset Hunk" },
      { "<Leader>gR", "<Cmd>Gitsigns reset_buffer<CR>", desc = "Reset Buffer" },
      { "ih", ":<C-u>Gitsigns select_hunk<CR>", desc = "Hunk", mode = { "o", "x" } },
      { "ah", ":<C-u>Gitsigns select_hunk<CR>", desc = "Hunk", mode = { "o", "x" } },
      { "]h", next_hunk_repeat, desc = "Next Hunk", mode = { "n", "o", "x" } },
      { "[h", prev_hunk_repeat, desc = "Prev Hunk", mode = { "n", "o", "x" } },
    }
  end,
  opts = {
    attach_to_untracked = true,
  },
}
