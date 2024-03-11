if vim.g.loaded_lsp then
  return
end

vim.g.loaded_lsp = 1

local lsp_start = vim.lsp.start
---@param config vim.lsp.ClientConfig
---@param start_opts? vim.lsp.start.Opts
---@diagnostic disable-next-line:duplicate-set-field
function vim.lsp.start(config, start_opts)
  -- require mason to load binary path
  require "mason"

  config.name = config.name or config.cmd[1]

  config.capabilities =
    vim.tbl_deep_extend("force", vim.lsp.protocol.make_client_capabilities(), config.capabilities or {})

  if config.root_markers then
    local file = vim.fs.find(config.root_markers, {
      upward = true,
      path = vim.api.nvim_buf_get_name(0),
    })

    if file and #file > 0 then
      config.root_dir = vim.fs.dirname(file[1])
    end

    ---@diagnostic disable-next-line:inject-field
    config.root_markers = nil
  end

  return lsp_start(config, start_opts)
end

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
  border = "single",
  title = " Documentation ",
})

vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers["textDocument/signatureHelp"], {
  border = "single",
  title = " Signature ",
})

vim.lsp.handlers["textDocument/publishDiagnostics"] =
  vim.lsp.with(vim.lsp.handlers["textDocument/publishDiagnostics"], {
    signs = {
      severity = { min = vim.diagnostic.severity.ERROR },
    },
    underline = {
      severity = { min = vim.diagnostic.severity.WARN },
    },
    virtual_text = true,
  })

vim.diagnostic.config {
  severity_sort = true,
  float = {
    border = "single",
  },
}

require "user.lsp.attach"
require "user.lsp.progress"
