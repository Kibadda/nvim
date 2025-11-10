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

  local line = ""
  local stdout = {}

  local command = {
    "git",
    "--no-pager",
    "-c",
    "color.ui=never",
  }

  vim.list_extend(command, cmd)
  vim.list_extend(command, fargs or {})

  local ret
  vim.fn.jobstart(command, {
    cwd = vim.fn.getcwd(),
    env = {
      GIT_EDITOR = vim.v.progpath .. " --headless --clean -u " .. client_path,
    },
    pty = true,
    width = 80,
    on_stdout = function(_, lines)
      line = line .. lines[1]:gsub("\r", "")

      for i = 2, #lines do
        table.insert(stdout, line)
        line = lines[i]:gsub("\r", "")
      end
    end,
    on_exit = function(_, code)
      if line ~= "" then
        table.insert(stdout, line)
      end

      if on_exit then
        on_exit(stdout, code)
      else
        ret = stdout
      end
    end,
  })

  if not on_exit then
    vim.wait(5000, function()
      return ret ~= nil
    end, 100)

    return ret
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

return M
