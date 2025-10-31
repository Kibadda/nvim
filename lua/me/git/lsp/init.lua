local M = {}

local methods = vim.lsp.protocol.Methods

local commands = {
  show_diff = function(arguments)
    local command = { "diff" }

    if arguments.action == "staged" then
      table.insert(command, "--cached")
    end

    local utils = require "git.utils"

    utils.open_buffer {
      name = "diff",
      lines = utils.git_command(vim.list_extend(command, arguments.paths)),
      treesitter = true,
      options = {
        modifiable = false,
        modified = false,
        filetype = "diff",
      },
    }
  end,

  unstage = function(paths)
    local cmd = { "restore", "--staged" }

    if require("git.status").branch() == "HEAD" then
      vim.list_extend(cmd, { "reset" })
    end

    require("git.utils").git_command(vim.list_extend(cmd, paths))
  end,

  add = function(paths)
    require("git.utils").git_command(vim.list_extend({ "add" }, paths))
  end,
}

--- @type lsp.ServerCapabilities
local capabilities = {
  codeActionProvider = true,
  executeCommandProvider = {
    commands = vim.tbl_keys(commands),
  },
}

local handlers = {
  [methods.initialize] = function(_, callback)
    callback(nil, { capabilities = capabilities })
  end,

  [methods.shutdown] = function(_, callback)
    callback(nil, nil)
  end,

  --- @type fun(params: lsp.CodeActionParams, callback: function)
  [methods.textDocument_codeAction] = function(params, callback)
    local bufnr = vim.uri_to_bufnr(params.textDocument.uri)
    local lines = vim.api.nvim_buf_get_lines(bufnr, 0, params.range["end"].line + 1, false)

    for i = params.range.start.line + 1, #lines do
      if not vim.startswith(lines[i], "\t") then
        return callback(nil, {})
      end
    end

    local arguments = { paths = {} }

    for i = params.range.start.line, 1, -1 do
      if not arguments.action and lines[i]:sub(1, 1) ~= " " then
        if lines[i] == "Untracked files:" then
          arguments.action = "untracked"
        elseif lines[i] == "Changes not staged for commit:" then
          arguments.action = "unstaged"
        elseif lines[i] == "Changes to be committed:" then
          arguments.action = "staged"
        end
      end
    end

    if not arguments.action then
      return callback(nil, {})
    end

    for i = params.range.start.line + 1, #lines do
      local path = vim.trim(lines[i])
      if path:find ":" then
        local split = vim.split(path, ":")
        path = vim.trim(split[#split])
      end
      table.insert(arguments.paths, path)
    end

    if #arguments.paths == 0 then
      callback(nil, {})
    end

    --- @type lsp.CodeAction[]
    local codeactions = {}

    if arguments.action ~= "untracked" then
      table.insert(codeactions, {
        title = "show diff",
        command = {
          title = "show diff",
          command = "show_diff",
          arguments = arguments,
        },
      })
      local action = arguments.action == "staged" and "unstage" or "add"
      table.insert(codeactions, {
        title = action,
        command = {
          title = action,
          command = action,
          arguments = arguments.paths,
        },
      })
    else
      table.insert(codeactions, {
        title = "add",
        command = {
          title = "add",
          command = "add",
          arguments = arguments.paths,
        },
      })
    end

    callback(nil, codeactions)
  end,

  --- @type fun(params: lsp.ExecuteCommandParams, callback: function)
  [methods.workspace_executeCommand] = function(params, callback)
    if commands[params.command] then
      commands[params.command](params.arguments)
    end

    callback(nil, {})
  end,
}

--- @param dispatchers vim.lsp.rpc.Dispatchers
local function cmd(dispatchers)
  --- @type vim.lsp.rpc.PublicClient
  --- @diagnostic disable-next-line:missing-fields
  local srv = {}
  local closing = false
  local request_id = 0

  local function next_id()
    request_id = request_id + 1
    return request_id
  end

  function srv.request(method, params, callback)
    local handler = handlers[method]
    if handler then
      handler(params, callback)
    end

    return true, next_id()
  end

  function srv.notify(method, _)
    if method == vim.lsp.protocol.Methods.exit then
      dispatchers.on_exit(0, 15)
    end
    return false
  end

  function srv.is_closing()
    return closing
  end

  function srv.terminate()
    closing = true
  end

  return srv
end

M.client_id = assert(vim.lsp.start({ cmd = cmd, name = "git", root_dir = vim.uv.cwd() }, { attach = false }))

function M.attach()
  vim.lsp.buf_attach_client(vim.api.nvim_get_current_buf(), M.client_id)
end

return M
