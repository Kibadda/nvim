local M = {
  cmd = { "restore" },
}

function M:pre_run(fargs)
  if #fargs == 0 or (#fargs == 1 and fargs[1] == "--staged") then
    table.insert(fargs, ".")
  end
end

function M.completions(fargs)
  if #fargs > 1 then
    if fargs[1] == "--staged" then
      return require("me.git.cache").staged
    else
      return require("me.git.cache").unstaged
    end
  else
    return vim.list_extend({ "--staged" }, require("me.git.cache").unstaged)
  end
end

return M
