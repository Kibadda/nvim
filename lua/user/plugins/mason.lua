return {
  "williamboman/mason.nvim",
  event = "VeryLazy",
  keys = {
    { "<Leader>lM", "<Cmd>Mason<CR>", desc = "Mason" },
  },
  opts = {
    ensure_installed = {
      "stylua",
      "css-lsp",
      "typescript-language-server",
      "intelephense",
      "lua-language-server",
      -- "json-lsp",
      -- "html-lsp",
      -- "bash-language-server",
      -- "beautysh",
      -- "pyright",
      -- "rnix-lsp",
      -- "sqlls",
      -- "vim-language-server",
    },
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
