local M = {
  "tpope/vim-fugitive",
  dependencies = {
    "tpope/vim-rhubarb",
    "shumphrey/fugitive-gitlab.vim",
  },
  cmd = {
    "G",
    "GBrowse",
    "Gvdiffsplit",
  },
}

function M.init()
  require("user.utils").keymaps {
    n = {
      ["<Leader>"] = {
        g = {
          d = { "<Cmd>Gvdiffsplit<CR>", "Diff" },
          D = {
            function()
              local branch =
                vim.fn.system("git branch -l master main | sed 's/^* //'"):gsub("^%s+", ""):gsub("%s+$", "")
              vim.cmd.Gvdiffsplit(branch)
            end,
            "Diff with Main",
          },
        },
      },
    },
  }

  vim.g.fugitive_gitlab_domains = {
    "https://git.cortex-media.de",
  }
end

return M
