return {
  "sam4llis/nvim-tundra",
  lazy = false,
  priority = 1000,
  keys = {
    {
      "<Leader>a",
      function()
        require("nvim-tundra.commands").toggle_transparency()

        vim.system {
          "kitty",
          "@",
          "--to",
          vim.env.KITTY_LISTEN_ON,
          "set-background-opacity",
          vim.g.tundra_opts.transparent_background and "0.9" or "1",
        }
      end,
      desc = "Toggle transparent background",
    },
  },
  opts = {
    transparent_background = true,
    overwrite = {
      highlights = {
        NormalFloat = { link = "Normal" },
      },
    },
  },
  config = function(_, opts)
    require("nvim-tundra").setup(opts)
    vim.cmd.colorscheme "tundra"
  end,
  enabled = true,
}
