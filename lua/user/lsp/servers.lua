---@type { filetypes: string[], root_markers: string[], config: vim.lsp.ClientConfig }[]
local servers = {
  {
    filetypes = { "php" },
    root_markers = { "composer.json", ".git" },
    config = {
      cmd = { "intelephense", "--stdio" },
      capabilities = {
        textDocument = { formatting = { dynamicRegistration = false } },
      },
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
          format = {
            braces = "psr12",
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
  },

  {
    filetypes = { "c" },
    root_markers = { ".clangd" },
    config = {
      cmd = { "clangd" },
    },
  },

  {
    filetypes = { "css", "scss" },
    config = {
      cmd = { "vscode-css-language-server", "--stdio" },
      capabilities = {
        textDocument = {
          completion = {
            completionItem = {
              snippetSupport = true,
            },
          },
        },
      },
      init_options = {
        provideFormatter = true,
      },
    },
  },

  {
    filetypes = { "javascript", "typescript", "vue" },
    root_markers = { "package.json" },
    config = {
      cmd = { "typescript-language-server", "--stdio" },
      before_init = function(params, config)
        if params.rootPath == vim.NIL then
          return
        end

        table.insert(config.init_options.plugins, {
          name = "@vue/typescript-plugin",
          location = params.rootPath .. "/node_modules/@vue/typescript-plugin",
          languages = { "javascript", "typescript", "vue" },
        })
      end,
      init_options = {
        plugins = {},
      },
    },
  },

  {
    filetypes = { "lua" },
    root_markers = { ".luarc.json", "stylua.toml" },
    config = {
      cmd = { "lua-language-server" },
      -- root_dir = root_dir { ".luarc.json", "stylua.toml" },
      before_init = function(params, config)
        if not params.rootPath or type(params.rootPath) ~= "string" then
          return
        end

        config.settings.Lua.workspace.library = config.settings.Lua.workspace.library or {}

        -- if inside neovim config
        ---@diagnostic disable-next-line:param-type-mismatch
        if params.rootPath:find(vim.fn.stdpath "config") then
          config.settings.Lua.runtime.version = "LuaJIT"

          -- add vimruntime
          table.insert(config.settings.Lua.workspace.library, vim.env.VIMRUNTIME .. "/lua")

          -- add lazy plugins
          for _, plugin in ipairs(require("lazy").plugins()) do
            ---@diagnostic disable-next-line:param-type-mismatch
            for _, p in ipairs(vim.fn.expand(plugin.dir .. "/lua", false, true)) do
              table.insert(config.settings.Lua.workspace.library, p)
            end
          end
        end

        -- if inside lua project
        if vim.fn.isdirectory(params.rootPath .. "/lua") == 1 then
          table.insert(config.settings.Lua.workspace.library, params.rootPath .. "/lua")
        end
      end,
      settings = {
        Lua = {
          runtime = {
            pathStrict = true,
          },
          format = {
            enable = false,
          },
          workspace = {
            checkThirdParty = false,
          },
          hint = {
            enable = true,
            arrayIndex = "Disable",
          },
          completion = {
            callSnippet = "Replace",
          },
        },
      },
    },
  },

  {
    filetypes = { "sh" },
    config = {
      cmd = { "bash-language-server", "start" },
    },
  },

  {
    filetypes = { "php" },
    root_markers = { "tailwind.config.js" },
    config = {
      cmd = { "tailwindcss-language-server", "--stdio" },
    },
  },
}

local group = vim.api.nvim_create_augroup("LspServers", { clear = true })
for _, server in ipairs(servers) do
  vim.api.nvim_create_autocmd("FileType", {
    group = group,
    pattern = server.filetypes,
    callback = function(args)
      if server.config.cmd[1] == "tailwindcss-language-server" and not args.file:match ".*%.view%.php" then
        return
      end

      require "mason"

      server.config.name = server.config.name or server.config.cmd[1]

      server.config.capabilities = vim.tbl_deep_extend("force", vim.lsp.protocol.make_client_capabilities(), {
        workspace = { didChangeWatchedFiles = { dynamicRegistration = false } },
      }, server.config.capabilities or {})

      if server.root_markers then
        local file = vim.fs.find(server.root_markers, {
          upward = true,
          path = vim.api.nvim_buf_get_name(args.buf),
        })

        if file and #file > 0 then
          server.config.root_dir = vim.fs.dirname(file[1])
        end
      end

      vim.lsp.start(server.config)
    end,
  })
end
