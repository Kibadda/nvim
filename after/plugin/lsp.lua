if not PluginsOk { "mason", "mason-lspconfig" } then
  return
end

require("mason").setup {
  ui = {
    border = "double",
    icons = {
      package_installed = "✓",
      package_pending = "➜",
      package_uninstalled = "✗",
    },
  },
}
require("mason-lspconfig").setup {
  ensure_installed = {
    "sumneko_lua",
    "intelephense",
    "cssls",
    "vimls",
    "tsserver",
    "hls",
  },
}

RegisterKeymaps("n", "<Leader>", {
  M = { "<Cmd>Mason<CR>", "Mason" },
})

if not vim.fn.exists "g:lsp_auto_format" then
  SetGlobal("lsp", {
    auto_format = false,
  })
end

local custom_attach = function(client)
  RegisterKeymaps("n", "", {
    K = { vim.lsp.buf.hover, "Hover" },
    ["gd"] = { vim.lsp.buf.definition, "Definition" },
    ["gr"] = { "<Cmd>Telescope lsp_references theme=ivy<CR>", "References" },
  }, { buffer = 0 })

  RegisterKeymaps("n", "<Leader>", {
    l = {
      name = "Lsp",
      c = { vim.lsp.buf.code_action, "Code Action" },
      f = { vim.lsp.buf.format, "Format" },
      j = { vim.diagnostic.goto_next, "Next Diagnostic" },
      k = { vim.diagnostic.goto_prev, "Prev Diagnostic" },
      d = { "<Cmd>Telescope diagnostics bufnr=0 theme=ivy<CR>", "Show Buffer Diagnostics" },
      w = { "<Cmd>Telescope diagnostics theme=ivy<CR>", "Show Diagnostics" },
      r = { vim.lsp.buf.rename, "Rename" },
      i = { "<Cmd>LspInfo<CR>", "Lsp Info" },
      t = { "<Cmd>ToggleAutoFormat<CR>", "Toggle Auto Format" },
    },
  }, { buffer = 0 })

  vim.bo.omnifunc = "v:lua.vim.lsp.omnifunc"

  if client.server_capabilities.documentHighlightProvider then
    local LspDocumentHighlight = vim.api.nvim_create_augroup("LspDocumentHighlight", { clear = false })
    vim.api.nvim_clear_autocmds {
      group = LspDocumentHighlight,
      buffer = 0,
    }
    vim.api.nvim_create_autocmd("CursorHold", {
      group = LspDocumentHighlight,
      buffer = 0,
      callback = vim.lsp.buf.document_highlight,
    })
    vim.api.nvim_create_autocmd("CursorMoved", {
      group = LspDocumentHighlight,
      buffer = 0,
      callback = vim.lsp.buf.clear_references,
    })
  end

  vim.api.nvim_create_autocmd("BufWritePre", {
    group = vim.api.nvim_create_augroup("LspFormatting", { clear = true }),
    pattern = "*",
    callback = function()
      if GetGlobal("lsp", "auto_format") and client.server_capabilities.documentFormattingProvider then
        vim.lsp.buf.format()
      end
    end,
  })
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
if PluginsOk "cmp_nvim_lsp" then
  capabilities = require("cmp_nvim_lsp").update_capabilities(capabilities)
end

local lspconfig = require "lspconfig"

local servers = {
  intelephense = {
    settings = {
      intelephense = {
        -- stylua: ignore
        stubs = {
          "apache", "apcu", "bcmath", "bz2", "calendar", "com_dotnet", "Core", "ctype", "curl",
          "date", "dba", "dom", "enchant", "exif", "FFI", "fileinfo", "filter", "fpm", "ftp",
          "gd", "gettext", "gmp", "hash", "iconv", "imap", "intl", "json", "ldap", "libxml",
          "mbstring", "meta", "mysqli", "oci8", "odbc", "openssl", "pcntl", "pcre", "PDO",
          "pdo_ibm", "pdo_mysql", "pdo_pgsql", "pdo_sqlite", "pgsql", "Phar", "posix", "pspell",
          "readline", "Reflection", "session", "shmop", "SimpleXML", "snmp", "soap", "sockets",
          "sodium", "SPL", "sqlite3", "standard", "superglobals", "sysvmsg", "sysvsem",
          "sysvshm", "tidy", "tokenizer", "xml", "xmlreader", "xmlrpc", "xmlwriter", "xsl",
          "Zend OPcache", "zip", "zlib", "wordpress", "phpunit",
        },
        phpdoc = {
          textFormat = "text",
          functionTemplate = {
            summary = "$1",
            tags = {
              "@param ${1:$SYMBOL_TYPE} $SYMBOL_NAME",
              "@return ${1:$SYMBOL_TYPE}",
              "@throws ${1:$SYMBOL_TYPE}",
            },
          },
        },
      },
    },
  },
  cssls = true,
  vimls = true,
  tsserver = true,
  hls = true,
}

local setup_server = function(server, config)
  if not config then
    return
  end

  if type(config) ~= "table" then
    config = {}
  end

  config = vim.tbl_deep_extend("force", {
    on_attach = custom_attach,
    capabilities = capabilities,
  }, config)

  lspconfig[server].setup(config)
end

for server, config in pairs(servers) do
  setup_server(server, config)
end

if PluginsOk "lua-dev" then
  local luadev = require("lua-dev").setup {
    lspconfig = {
      on_attach = custom_attach,
      capabilities = capabilities,
      settings = {
        Lua = {
          format = {
            enable = false,
          },
          workspace = {
            checkThirdParty = false,
          },
        },
      },
    },
  }

  lspconfig.sumneko_lua.setup(luadev)
end

if PluginsOk "null-ls" then
  require("null-ls").setup {
    sources = {
      require("null-ls").builtins.formatting.stylua,
    },
  }
end