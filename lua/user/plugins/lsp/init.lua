return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "folke/neoconf.nvim",
    "folke/neodev.nvim",
    "MrcJkb/haskell-tools.nvim",
    "williamboman/mason.nvim",
  },
  lazy = false,
  keys = {
    { "<Leader>lL", "<Cmd>LspInfo<CR>", desc = "LspInfo" },
  },
  config = function()
    require("neoconf").setup {}
    require("neodev").setup {}

    local function on_attach(client, bufnr)
      client.server_capabilities.semanticTokensProvider = nil

      require("user.plugins.lsp.keymaps").setup(bufnr)
      require("user.plugins.lsp.formatting").setup(client, bufnr)
      require("user.plugins.lsp.highlighting").setup(client, bufnr)
      require("user.plugins.lsp.codelens").setup(client, bufnr)

      if client.server_capabilities.inlayHintProvider then
        require("user.plugins.lsp.inlay_hints").setup()
      end
    end

    local ok, wf = pcall(require, "vim.lsp._watchfiles")
    if ok then
      -- disable lsp watcher. Too slow on linux
      wf._watchfunc = function()
        return function() end
      end
    end

    for server, opts in pairs(require "user.plugins.lsp.servers") do
      if opts then
        opts = vim.tbl_deep_extend("force", {}, {
          on_attach = on_attach,
          capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities()),
        }, type(opts) == "boolean" and {} or opts)
        if server == "hls" then
          require("haskell-tools").setup {
            hls = {
              on_attach = on_attach,
            },
          }
        else
          require("lspconfig")[server].setup(opts)
        end
      end
    end

    -- require("lspconfig").ocamllsp.setup {
    --   on_attach = on_attach,
    --   capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities()),
    -- }

    require("user.plugins.lsp.handlers").setup()
    require("user.plugins.lsp.diagnostic").setup()

    -- set border of LspInfo window
    require("lspconfig.ui.windows").default_options.border = "single"
  end,
}
