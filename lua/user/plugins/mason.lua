return {
  "williamboman/mason.nvim",
  event = "VeryLazy",
  keys = {
    { "<Leader>lM", "<Cmd>Mason<CR>", desc = "Mason" },
  },
  opts = {
    ui = {
      border = "single",
      icons = {
        package_installed = "✓",
        package_pending = "➜",
        package_uninstalled = "✗",
      },
    },
  },
}
