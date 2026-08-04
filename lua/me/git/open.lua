local M = {}

function M.project()
  local url = require("me.git.utils").get_url()

  if url then
    vim.ui.open(url)
  end
end

function M.file()
  local url = require("me.git.utils").get_url()

  if not url then
    return
  end

  local branch = require("me.git.utils").run({ "rev-parse" }, { "--abbrev-ref", "HEAD" })[1]

  if not branch or branch == "" then
    return
  end

  local bufname = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":.")

  url = url .. "/blob/" .. branch .. "/" .. bufname

  if vim.fn.mode() == "V" then
    local sline = vim.fn.line "v"
    local eline = vim.fn.line "."

    if sline > eline then
      sline, eline = eline, sline
    end

    url = url .. "#L" .. sline .. "-L" .. eline
  end

  vim.ui.open(url)
end

return M
