vim.opt_local.tabstop = 4
vim.opt_local.shiftwidth = 4

vim.lsp.start {
  name = "intelephense",
  cmd = { "intelephense", "--stdio" },
  filetypes = { "php" },
  root_markers = { "composer.json", ".git" },
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
        braces = vim.env.LOCATION == "work" and "k&r" or "psr12",
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
}
