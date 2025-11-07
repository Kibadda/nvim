local M = {
  cmd = { "switch" },
}

function M:pre_run(fargs)
  if #fargs > 1 then
    return false
  end

  if #fargs == 0 then
    local branch

    vim.ui.input({ prompt = "Enter branch name: " }, function(input)
      branch = input
    end)

    if not branch or branch == "" then
      return false
    end

    vim.list_extend(fargs, { "--create", branch })
  end
end

function M.completions(fargs)
  if #fargs > 1 then
    return {}
  else
    return require("me.git.cache").short_branch
  end
end

return M
