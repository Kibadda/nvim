return {
  "ThePrimeagen/refactoring.nvim",
  config = true,
  keys = {
    { "<Leader>r", mode = "x" },
  },
  init = function()
    require("user.utils").keymaps {
      x = {
        ["<Leader>"] = {
          r = { ":lua require('refactoring').select_refactor()<CR>", "Refactor" },
        },
      },
    }
  end,
}
