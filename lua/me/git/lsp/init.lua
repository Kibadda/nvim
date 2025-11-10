local M = {}

local methods = vim.lsp.protocol.Methods

local commands = {
  show_diff = function(arguments)
    require("me.git.commands").diff:run(vim.list_extend(arguments.cached and { "--cached" } or {}, arguments.files))
  end,

  unstage = function(arguments)
    require("me.git.commands").restore:run(vim.list_extend({ "--staged" }, arguments.files))
    vim.b[arguments.bufnr].refresh()
  end,

  add = function(arguments)
    require("me.git.commands").add:run(vim.list_extend(arguments.edit and { "--edit" } or {}, arguments.files))
    vim.b[arguments.bufnr].refresh()
  end,

  apply_patch = function(arguments)
    local tmp = vim.fn.tempname()
    vim.fn.writefile(arguments.patch, tmp)

    require("me.git.utils").run(
      { "apply" },
      vim.list_extend(arguments.reverse and { "--reverse" } or {}, { "--cached", tmp }),
      function()
        vim.b[arguments.bufnr].refresh()
      end
    )
  end,
}

--- @type lsp.ServerCapabilities
local capabilities = {
  codeActionProvider = true,
  executeCommandProvider = {
    commands = vim.tbl_keys(commands),
  },
  hoverProvider = true,
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

    local codeactions = {}

    if vim.b[bufnr].lsp and vim.b[bufnr].lsp[methods.textDocument_codeAction] then
      codeactions = vim.b[bufnr].lsp[methods.textDocument_codeAction](params)
    end

    callback(nil, codeactions)
  end,

  --- @type fun(params: lsp.HoverParams, callback: function)
  [methods.textDocument_hover] = function(params, callback)
    local bufnr = vim.uri_to_bufnr(params.textDocument.uri)

    if vim.b[bufnr].lsp and vim.b[bufnr].lsp[methods.textDocument_hover] then
      vim.b[bufnr].lsp[methods.textDocument_hover](params)
    end

    callback(nil, { contents = " " })
  end,

  --- @type fun(params: lsp.ExecuteCommandParams, callback: function)
  [methods.workspace_executeCommand] = function(params, callback)
    if commands[params.command] then
      commands[params.command](params.arguments)
    end

    callback(nil, {})
  end,

  --- @type fun(params: lsp.HoverParams, callback: function)
  [methods.textDocument_hover] = function(params, callback)
    local bufnr = vim.uri_to_bufnr(params.textDocument.uri)

    local hover

    if vim.b[bufnr].lsp and vim.b[bufnr].lsp[methods.textDocument_hover] then
      hover = vim.b[bufnr].lsp[methods.textDocument_hover](params)
    end

    callback(nil, hover)
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
