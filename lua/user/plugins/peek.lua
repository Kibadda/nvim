return {
  "toppair/peek.nvim",
  build = "deno task --quiet build:fast",
  ft = "markdown",
  keys = {
    {
      "<Leader>mp",
      function()
        require("peek").open()
      end,
      desc = "Start",
    },
    {
      "<Leader>ms",
      function()
        require("peek").close()
      end,
      desc = "Stop",
    },
  },
  opts = {
    update_on_change = false,
  },
  enabled = false,
}
