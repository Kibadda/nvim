return {
  "rest-nvim/rest.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  ft = "http",
  keys = {
    {
      "<Leader>H",
      function()
        require("rest-nvim").run()
      end,
      desc = "Run request",
    },
  },
  opts = {
    skip_ssl_verification = true,
  },
}
