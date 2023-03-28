return {
  "nvim-neotest/neotest",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-neotest/neotest-plenary",
  },
  enabled = false,
  opts = function()
    return {
      adapters = {
        require "neotest-plenary",
      },
    }
  end,
}
