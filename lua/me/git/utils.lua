local M = {}

local client_path

local function ensure_git_editor()
  if not client_path or vim.fn.filereadable(client_path) == 0 then
    client_path = vim.fn.tempname()

    vim.fn.writefile({
      "lua << EOF",
      string.format("local socket = vim.fn.sockconnect('pipe', '%s', { rpc = true })", vim.v.servername),
      [[local cmd = string.format('require("me.git.editor").start("%s", "%s")', vim.fn.argv(0), vim.v.servername)]],
      "vim.rpcrequest(socket, 'nvim_exec_lua', cmd, {})",
      "EOF",
    }, client_path)
  end
end

function M.run(cmd, fargs, on_exit)
  ensure_git_editor()

  local command = {
    "--no-pager",
    "-c",
    "color.ui=never",
  }

  vim.list_extend(command, cmd)
  vim.list_extend(command, fargs or {})

  local editor = vim.v.progpath .. " --headless --clean -u " .. client_path

  local env = {}
  for k, v in
    pairs(vim.tbl_extend("force", vim.uv.os_environ(), {
      GIT_EDITOR = editor,
      GIT_SEQUENCE_EDITOR = editor,
      GIT_PAGER = "",
      NO_COLOR = 1,
      TERM = "dumb",
    }))
  do
    table.insert(env, string.format("%s=%s", k, tostring(v)))
  end

  local process
  local stdout = assert(vim.uv.new_pipe())
  local out = {}
  local ret, exit_code, is_done
  local opts = {
    args = command,
    cwd = vim.fn.getcwd(),
    env = env,
    stdio = {
      nil,
      stdout,
      nil,
    },
  }
  process = vim.uv.spawn("git", opts, function(code)
    if is_done then
      return
    end
    is_done = true
    if process:is_closing() then
      return
    end
    process:close()

    local trimmed_out = table.concat(out):gsub("\n+$", "")

    if trimmed_out ~= "" then
      out = vim.split(trimmed_out, "\n")
    else
      out = {}
    end

    if on_exit then
      vim.schedule(function()
        on_exit(out, code)
      end)
    else
      ret = out
      exit_code = code
    end
  end)

  stdout:read_start(function(e, data)
    if e then
      return table.insert(out, 1, "ERROR: " .. e)
    end
    if data ~= nil then
      return table.insert(out, data)
    end
    stdout:close()
  end)

  if not on_exit then
    vim.wait(5000, function()
      return ret ~= nil
    end, 100)

    return ret, exit_code
  end
end

local function ui_select(opts)
  local lines = {}

  for _, line in ipairs(M.run(opts.cmd, opts.args)) do
    if line ~= "" then
      table.insert(lines, opts.decode and opts.decode(line) or line)
    end
  end

  if #lines <= 1 then
    return opts.choice and opts.choice(lines[1]) or lines[1]
  end

  local choice

  vim.ui.select(lines, {
    prompt = opts.prompt,
    format_item = opts.format,
  }, function(item)
    choice = opts.choice and opts.choice(item) or item
  end)

  return choice
end

function M.select_commit()
  return ui_select {
    cmd = { "log" },
    args = { "--pretty=%h|%s" },
    prompt = "Commit",
    decode = function(line)
      return vim.split(line, "|")
    end,
    format = function(item)
      return item[2]
    end,
    choice = function(item)
      return item and item[1] or nil
    end,
  }
end

function M.select_remote()
  return ui_select {
    cmd = { "remote" },
    prompt = "Remote",
  }
end

function M.select_stash()
  return ui_select {
    cmd = { "stash", "list" },
    prompt = "Stash",
    decode = function(line)
      return { line:match "^(stash@{%d+}): (.+)$" }
    end,
    format = function(item)
      return item[2]
    end,
    choice = function(item)
      return item and item[1] or nil
    end,
  }
end

function M.get_url()
  local remote = M.run({ "remote" })[1]

  if not remote or remote == "" then
    return
  end

  local url = M.run({ "config" }, { "--get", string.format("remote.%s.url", remote) })[1]

  if not url or url == "" then
    return
  end

  if url:match "^.+@" then
    url = url:gsub("%.git", ""):gsub(":", "/"):gsub("^.+@", "https://")
  end

  return url
end

return M
