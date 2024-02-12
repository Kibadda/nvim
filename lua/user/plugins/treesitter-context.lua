return {
  "nvim-treesitter/nvim-treesitter-context",
  lazy = false,
  keys = {
    {
      "[c",
      function()
        require("treesitter-context").go_to_context(vim.v.count1)
      end,
      desc = "Goto previous context",
    },
  },
  opts = {
    max_lines = 1,
  },
}
