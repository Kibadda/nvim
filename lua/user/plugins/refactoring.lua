return {
  "ThePrimeagen/refactoring.nvim",
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
  enabled = false,
}
