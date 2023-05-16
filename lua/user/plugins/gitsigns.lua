return {
  "lewis6991/gitsigns.nvim",
  event = "VeryLazy",
  opts = {
    on_attach = function(bufnr)
      require("user.utils").keymaps {
        [{ mode = "n", buffer = bufnr }] = {
          ["<Leader>"] = {
            g = {
              name = "Git",
              j = { "<Cmd>Gitsigns next_hunk<CR>", "Next Hunk" },
              k = { "<Cmd>Gitsigns prev_hunk<CR>", "Prev Hunk" },
              l = { "<Cmd>Gitsigns blame_line<CR>", "Blame Line" },
              s = { "<Cmd>Telescope git_status<CR>", "Status" },
              b = { "<Cmd>Telescope git_branches<CR>", "Checkout Branches" },
              c = { "<Cmd>Telescope git_commits<CR>", "Checkout Commit" },
              C = { "<Cmd>Telescope git_bcommits<CR>", "Checkout Commit (current file)" },
              r = { "<Cmd>Gitsigns reset_hunk<CR>", "Reset Hunk" },
              R = { "<Cmd>Gitsigns reset_buffer<CR>", "Reset Buffer" },
              g = { "<Cmd>Gitsigns stage_hunk<CR>", "Stage Hunk" },
              G = { "<Cmd>Gitsigns stage_buffer<CR>", "Stage Buffer" },
              u = { "<Cmd>Gitsigns undo_stage_hunk<CR>", "Undo Stage Hunk" },
            },
          },
        },
        [{ mode = { "o", "x" }, buffer = bufnr }] = {
          ih = { ":<C-u>Gitsigns select_hunk<CR>", "Hunk" },
          ah = { ":<C-u>Gitsigns select_hunk<CR>", "Hunk" },
        },
      }

      local ts = require "nvim-treesitter.textobjects.repeatable_move"
      local gs = require "gitsigns"
      local next_hunk_repeat, prev_hunk_repeat = ts.make_repeatable_move_pair(gs.next_hunk, gs.prev_hunk)

      require("user.utils").keymaps {
        [{ mode = { "n", "x", "o" } }] = {
          ["]h"] = { next_hunk_repeat, "Next Hunk" },
          ["[h"] = { prev_hunk_repeat, "Prev Hunk" },
        },
      }
    end,
  },
}
