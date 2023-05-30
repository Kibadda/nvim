return {
  "williamboman/mason.nvim",
  dependencies = {
    "jayp0521/mason-null-ls.nvim",
    "jose-elias-alvarez/null-ls.nvim",
    "williamboman/mason-lspconfig.nvim",
  },
  keys = {
    { "<Leader>lM", "<Cmd>Mason<CR>", desc = "Mason" },
  },
  config = function()
    require("mason").setup {
      ui = {
        border = "single",
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
    }

    require("mason-lspconfig").setup {
      ensure_installed = vim.tbl_keys(require "user.plugins.lsp.servers"),
    }

    local null_ls = require "null-ls"
    require("mason-null-ls").setup {
      ensure_installed = {
        "stylua",
        "beautysh",
      },
      automatic_installation = true,
      handlers = {
        stylua = function()
          null_ls.register(null_ls.builtins.formatting.stylua)
        end,
        beautysh = function()
          null_ls.register(null_ls.builtins.formatting.beautysh.with {
            extra_args = function(params)
              return params.options
                and params.options.tabSize
                and {
                  "-i",
                  params.options.tabSize,
                }
            end,
          })
        end,
      },
    }

    null_ls.setup {}
  end,
}
