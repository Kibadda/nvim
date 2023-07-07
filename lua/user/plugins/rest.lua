return {
  "rest-nvim/rest.nvim",
  enabled = false,
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
