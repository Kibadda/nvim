local methods = require "user.config-lsp.methods"
local commands = require "user.config-lsp.commands"

local M = {
  ---@type lsp.Client?
  client = nil,
}

---@type lsp.ClientConfig
M.config = {
  name = "config-lsp",
  cmd = function()
    local message_id = 0

    ---@type vim.lsp.rpc.PublicClient
    return {
      is_closing = function()
        return false
      end,
      terminate = function() end,
      notify = function(method, params)
        if methods.notify[method] then
          return methods.notify[method](params)
        end

        return false
      end,
      request = function(method, params, callback)
        local err, response

        if methods.request[method] then
          err, response = methods.request[method](params, commands)
        else
          err = vim.lsp.rpc_response_error(vim.lsp.protocol.ErrorCodes.MethodNotFound)
        end

        callback(err, response)

        if not err then
          message_id = message_id + 1

          return true, message_id
        else
          return false
        end
      end,
    }
  end,
  init_options = {},
}

function M.start()
  local id = vim.lsp.start(M.config)
  if id then
    M.client = vim.lsp.get_client_by_id(id)
  end
end

return M
