local M = {
  cmd = { "merge" },
}

function M:pre_run(fargs)
  return #fargs == 1
end

function M.completions(fargs)
  if #fargs > 1 then
    return {}
  else
    return require("me.git.cache").full_branch
  end
end

return M
