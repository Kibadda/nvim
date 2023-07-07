return {
  "ThePrimeagen/refactoring.nvim",
  enabled = false,
  config = true,
  keys = {
    {
      "<Leader>r",
      function()
        require("refactoring").select_refactor()
      end,
      desc = "Refactor",
      mode = "x",
    },
  },
}
