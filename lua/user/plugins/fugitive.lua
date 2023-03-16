local M = {
  "tpope/vim-rhubarb",
  dependencies = {
    "tpope/vim-fugitive",
    "shumphrey/fugitive-gitlab.vim",
  },
  cmd = {
    "G",
    "GBrowse",
    "Gvdiffsplit",
  },
}

function M.init()
  require("user.utils.register").keymaps {
    n = {
      ["<Leader>"] = {
        g = {
          d = { "<Cmd>Gvdiffsplit<CR>", "Diff" },
        },
      },
    },
  }

  vim.g.fugitive_gitlab_domains = {
    "https://git.cortex-media.de",
  }
end

return M
