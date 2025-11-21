if vim.g.loaded_plugin_lsp then
  return
end

vim.g.loaded_plugin_lsp = 1

vim.lsp.log.set_level(vim.log.levels.WARN)

vim.diagnostic.config {
  severity_sort = true,
  jump = {
    on_jump = function(_, bufnr)
      vim.diagnostic.open_float {
        bufnr = bufnr,
        scope = "cursor",
        focus = false,
      }
    end,
  },
  signs = {
    severity = { min = vim.diagnostic.severity.ERROR },
  },
  underline = {
    severity = { min = vim.diagnostic.severity.WARN },
  },
  virtual_text = true,
}

require "me.lsp.attach"
require "me.lsp.progress"

vim.lsp.enable {
  "lua-language-server",
  "nil",
  "intelephense",
  "typescript-language-server",
  "tinymist",
}
