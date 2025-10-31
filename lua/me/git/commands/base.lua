local M = {}
M.__index = M

local client_path

function M:run(fargs)
  local cmd = vim.list_extend({
    "git",
    "--no-pager",
    "-c",
    "color.ui=never",
    "-q", -- TODO: test if this works for all commands
  }, self.cmd)

  if self.pre_run then
    if self:pre_run(fargs) == false then
      return
    end
  end

  local line = ""
  local stdout = {}

  if not client_path or not vim.fn.filereadable(client_path) == 0 then
    client_path = vim.fn.tempname()
    vim.fn.writefile({
      "lua << EOF",
      string.format("local socket = vim.fn.sockconnect('pipe', '%s', { rpc = true })", vim.v.servername),
      [[local cmd = string.format('require("me.git.server").open("%s", "%s")', vim.fn.argv(0), vim.v.servername)]],
      "vim.rpcrequest(socket, 'nvim_exec_lua', cmd, {})",
      "EOF",
    }, client_path)
  end

  vim.fn.jobstart(vim.list_extend(cmd, fargs), {
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

      self:on_exit(stdout, code)
    end,
  })
end

function M:complete(arg_lead)
  local split = vim.split(arg_lead, "%s+")

  local completions = self.completions or {}

  if type(completions) == "function" then
    completions = completions(split)
  end

  local complete = vim.tbl_filter(function(opt)
    if vim.tbl_contains(split, opt) then
      return false
    end

    return not string.find(opt, "^" .. split[#split]:gsub("%-", "%%-"))
  end, completions)

  table.sort(complete)

  return complete
end

function M:on_exit(stdout, code)
  vim.print { stdout, code }
  -- local options = {
  --   name = self.cmd[1],
  --   lines = stdout,
  --   options = {
  --     modifiable = false,
  --     modified = false,
  --   },
  -- }
  --
  -- if type(self.show_output) == "function" then
  --   options = vim.tbl_deep_extend("force", self.show_output(options))
  -- end
  --
  -- require("me.git.utils").open_buffer(options)
end

function M.new(opts)
  return setmetatable(opts, M)
end

return M
