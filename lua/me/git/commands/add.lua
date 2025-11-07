local M = {
  cmd = { "add" },
}

function M:pre_run(fargs)
  if #fargs == 0 or (#fargs == 1 and fargs[1] == "--edit") then
    table.insert(fargs, ".")
  end
end

function M.completions(fargs)
  return vim.list_extend(#fargs > 1 and {} or { "--edit" }, require("me.git.cache").unstaged)
end

return M
