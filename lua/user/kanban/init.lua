local M = {}

local SHOWN = false
---@type integer?
local TABPAGE = nil

local windows = require "user.kanban.windows"

function M.create()
  vim.cmd.tabnew()
  local tabpage = vim.api.nvim_get_current_tabpage()
  local scratchbuf = vim.api.nvim_get_current_buf()
  vim.bo[scratchbuf].bufhidden = "delete"
  vim.bo[scratchbuf].buflisted = false

  windows.create()

  vim.schedule(function()
    windows.issues()
  end)

  return tabpage
end

function M.toggle()
  if SHOWN then
    M.close()
  else
    M.show()
  end
end

function M.show()
  if SHOWN then
    return
  end

  if not TABPAGE or not vim.api.nvim_tabpage_is_valid(TABPAGE) then
    TABPAGE = M.create()
  end

  vim.api.nvim_set_current_tabpage(TABPAGE)

  vim.api.nvim_set_current_win(windows.groups[windows.current].win)

  SHOWN = true
end

function M.close()
  if not TABPAGE or not vim.api.nvim_tabpage_is_valid(TABPAGE) then
    TABPAGE = nil

    return
  end

  windows.destroy()
  vim.cmd.tabclose()

  TABPAGE = nil
  SHOWN = false
end

return M
