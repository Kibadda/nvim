local M = {
  "tpope/vim-rhubarb",
  dependencies = {
    "tpope/vim-fugitive",
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
end

return M
