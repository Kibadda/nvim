local M = {
  "nvim-neotest/neotest",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    "nvim-neotest/neotest-plenary",
  },
}

function M.config()
  require("neotest").setup {
    adapters = {
      require "neotest-plenary",
    },
  }
end

return M
