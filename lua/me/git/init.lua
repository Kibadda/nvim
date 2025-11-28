-- TODO: loader during commands

local M = {}

function M.run(data)
  local cmd = table.remove(data.fargs, 1)

  if not cmd then
    cmd = "status"
  end

  local command = require("me.git.commands")[cmd]

  if not command then
    vim.notify("command '" .. cmd .. "' not found")
    return
  end

  command:run(data.fargs)
end

function M.complete(cmdline)
  local cmd, cmd_arg_lead = cmdline:match "^Gi?t?%s+(%S+)%s+(.*)$"

  local commands = require "me.git.commands"

  if cmd and commands[cmd] and cmd_arg_lead then
    return commands[cmd]:complete(cmd_arg_lead)
  end

  cmd = cmdline:match "^Gi?t?%s+(.*)$"

  if cmd then
    local complete = vim.tbl_filter(function(command)
      return string.find(command, "^" .. cmd) ~= nil
    end, vim.tbl_keys(commands))

    table.sort(complete)

    return complete
  end
end

return M
