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
  config = function(_, opts)
    require("mason").setup(opts)

    local installed = require("mason-registry").get_installed_package_names()
    for _, name in ipairs {
      "stylua",
      "css-lsp",
      "typescript-language-server",
      "intelephense",
      "lua-language-server",
      "bash-language-server",
      "beautysh",
    } do
      if not vim.tbl_contains(installed, name) then
        require("mason-registry").get_package(name):install()
      end
    end
  end,
}
