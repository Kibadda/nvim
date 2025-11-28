local M = {}

local methods = vim.lsp.protocol.Methods

M.commands = {
  diff = function(arguments)
    require("me.git.commands").diff:run(vim.list_extend(arguments.cached and { "--cached" } or {}, arguments.files))
  end,

  open = function(arguments)
    if arguments.commit then
      local url = require("me.git.utils").get_url()
      local rev = require("me.git.utils").run({ "rev-parse" }, { "--verify", arguments.commit })[1]

      vim.ui.open(url .. "/commit/" .. rev)
    end
  end,

  restore = function(arguments)
    require("me.git.commands").restore:run(vim.list_extend(arguments.staged and { "--staged" } or {}, arguments.files))
  end,

  add = function(arguments)
    require("me.git.commands").add:run(vim.list_extend(arguments.edit and { "--edit" } or {}, arguments.files))
  end,

  apply_patch = function(arguments)
    local tmp = vim.fn.tempname()
    vim.fn.writefile(arguments.patch, tmp)

    require("me.git.utils").run(
      { "apply" },
      vim.list_extend(arguments.reverse and { "--reverse" } or {}, { "--cached", tmp }),
      function()
        vim.api.nvim_exec_autocmds("User", {
          pattern = "GitPostRun",
        })
      end
    )
  end,
}

local handlers = {
  --- @type fun(_, callback: fun(_, result: lsp.InitializeResult))
  [methods.initialize] = function(_, callback)
    callback(nil, {
      serverInfo = {
        name = "git",
        version = "1.0",
      },
      capabilities = {
        codeActionProvider = true,
        executeCommandProvider = {
          commands = vim.tbl_keys(M.commands),
        },
        hoverProvider = true,
        signatureHelpProvider = {},
        definitionProvider = true,
      },
    })
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
    else
      return
    end

    callback(nil, codeactions)
  end,

  --- @type fun(params: lsp.HoverParams, callback: function)
  [methods.textDocument_hover] = function(params, callback)
    local bufnr = vim.uri_to_bufnr(params.textDocument.uri)

    if vim.b[bufnr].lsp and vim.b[bufnr].lsp[methods.textDocument_hover] then
      vim.b[bufnr].lsp[methods.textDocument_hover](params)
    else
      return
    end

    callback(nil, { contents = " " })
  end,

  --- @type fun(params: lsp.DefinitionParams, callback: function)
  [methods.textDocument_definition] = function(params, callback)
    local bufnr = vim.uri_to_bufnr(params.textDocument.uri)

    if vim.b[bufnr].lsp and vim.b[bufnr].lsp[methods.textDocument_definition] then
      vim.b[bufnr].lsp[methods.textDocument_definition](params)
    else
      return
    end

    local pos = vim.api.nvim_win_get_cursor(0)

    callback(nil, {
      uri = params.textDocument.uri,
      ---@type lsp.Range
      range = {
        start = { line = pos[1] - 1, character = pos[2] },
        ["end"] = { line = pos[1] - 1, character = pos[2] },
      },
    })
  end,

  --- @type fun(params: lsp.ExecuteCommandParams, callback: function)
  [methods.workspace_executeCommand] = function(params, callback)
    if M.commands[params.command] then
      M.commands[params.command](params.arguments)
    else
      return
    end

    callback(nil, {})
  end,

  --- @type fun(params: lsp.SignatureHelpParams, callback: function)
  [methods.textDocument_signatureHelp] = function(params, callback)
    local bufnr = vim.uri_to_bufnr(params.textDocument.uri)

    if vim.b[bufnr].lsp and vim.b[bufnr].lsp[methods.textDocument_signatureHelp] then
      vim.b[bufnr].lsp[methods.textDocument_signatureHelp](params)
    else
      return
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
