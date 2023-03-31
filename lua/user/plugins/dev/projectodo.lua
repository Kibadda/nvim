return {
  "Kibadda/projectodo.nvim",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "tpope/vim-dotenv",
  },
  dev = true,
  opts = {
    sources = {
      git = {
        enabled = vim.env.LOCATION == "work",
        url = "https://git.cortex-media.de/api/v4/projects/197/issues?state=opened",
        ignore_labels = { "Doing", "Recurring" },
        force = false,
        uses_session = true,
        adapter = "gitlab",
      },
      treesitter = {
        enabled = false,
        dir = "$HOME/notes",
        header = "Current projects",
        main = "index",
        filetype = "norg",
      },
      session = {
        enabled = true,
      },
    },
  },
}
