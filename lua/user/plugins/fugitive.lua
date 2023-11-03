return {
  "tpope/vim-fugitive",
  enabled = false,
  dependencies = {
    "tpope/vim-rhubarb",
    "shumphrey/fugitive-gitlab.vim",
  },
  cmd = {
    "G",
    "GBrowse",
    "Gvdiffsplit",
  },
  keys = {
    {
      "<Leader>gd",
      function()
        vim.cmd.Gvdiffsplit()
      end,
      desc = "Diff",
    },
    {
      "<Leader>gD",
      function()
        local branch = vim
          .system({
            "git",
            "branch",
            "-l",
            "master",
            "main",
          }, { text = true })
          :wait().stdout
          :gsub("^%*%s*", "")
          :gsub("%s+$", "")
        vim.cmd.Gvdiffsplit(branch)
      end,
      desc = "Diff with Main",
    },
  },
  init = function()
    vim.g.fugitive_gitlab_domains = {
      "https://git.cortex-media.de",
    }
  end,
}
