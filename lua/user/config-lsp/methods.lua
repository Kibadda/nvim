local m = vim.lsp.protocol.Methods
local initialized = false

return {
  notify = {
    [m.initialized] = function(_)
      return true
    end,
  },
  request = {
    ---@param _ lsp.InitializeParams
    ---@param commands string[]
    ---@return lsp.ResponseError?, lsp.InitializeResult?
    [m.initialize] = function(_, commands)
      if not initialized then
        initialized = true

        return nil,
          {
            ---@type lsp.ServerCapabilities
            capabilities = {
              completionProvider = {},
              executeCommandProvider = {
                commands = vim.tbl_keys(commands),
              },
              codeLensProvider = {},
              implementationProvider = true,
            },
          }
      end

      return vim.lsp.rpc_response_error(vim.lsp.protocol.ErrorCodes.InvalidRequest)
    end,

    ---@param params lsp.CompletionParams
    ---@return lsp.ResponseError?, lsp.CompletionItem[]
    [m.textDocument_completion] = function(params)
      local items = {}

      local completions = require "user.config-lsp.completions"
      completions(params, items)

      return nil, items
    end,

    ---@param params lsp.ExecuteCommandParams
    ---@param commands table<string, function>
    ---@return lsp.ResponseError?, lsp.LSPAny
    [m.workspace_executeCommand] = function(params, commands)
      if commands[params.command] then
        return nil, commands[params.command](params.arguments)
      end

      return vim.lsp.rpc_response_error(vim.lsp.protocol.ErrorCodes.InvalidRequest)
    end,

    ---@param params lsp.CodeLensParams
    ---@return lsp.ResponseError?, lsp.CodeLens[]
    [m.textDocument_codeLens] = function(params)
      local lenses = {}

      local codelenses = require "user.config-lsp.codelenses"
      codelenses(params, lenses)

      return nil, lenses
    end,

    ---@param params lsp.ImplementationParams
    ---@return lsp.ResponseError?, lsp.LSPAny
    [m.textDocument_implementation] = function(params)
      local cache = require "user.plugin-cache"
      local buf = vim.uri_to_bufnr(params.textDocument.uri)
      local loc

      if #cache[buf] == 1 then
        loc = cache[buf][1]
      elseif #cache[buf] > 1 then
        local line = unpack(vim.api.nvim_win_get_cursor(0))

        for _, plug in ipairs(cache[buf]) do
          if line - 1 == plug.range[1] then
            loc = plug
          end
        end

        if not loc then
          vim.ui.select(cache[buf], {
            prompt = "Select plugin to open",
          }, function(choice)
            loc = choice
          end)
        end
      end

      if loc then
        require("user.config-lsp").client.request(m.workspace_executeCommand, {
          command = "open_plugin_in_browser",
          arguments = loc,
        }, nil, buf)
      end

      return nil, {}
    end,
  },
}
