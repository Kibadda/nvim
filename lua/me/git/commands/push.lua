local M = {
  cmd = { "push" },
}

function M:pre_run(fargs)
  if #fargs > 1 then
    return false
  end

  if #fargs == 1 and fargs[1] == "--set-upstream" then
    local remote = require("me.git.utils").select_remote()

    if not remote then
      return false
    end

    vim.list_extend(fargs, { remote, require("me.git.utils").run({ "branch" }, { "--show-current" })[1] })
  end
end

function M.completions(fargs)
  if #fargs > 1 then
    return {}
  else
    return { "--force-with-lease", "--set-upstream" }
  end
end

return M
