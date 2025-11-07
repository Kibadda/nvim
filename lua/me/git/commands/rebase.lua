local M = {
  cmd = { "rebase" },
}

function M:pre_run(fargs)
  local should_select = true

  for _, arg in ipairs(fargs) do
    if vim.tbl_contains({ "--abort", "--skip", "--continue" }, arg) or not vim.startswith(arg, "--") then
      should_select = false
      break
    end
  end

  if should_select then
    local commit = require("me.git.utils").select_commit()

    if not commit then
      return false
    end

    -- TODO: use --root for commit if it is the first commit

    table.insert(fargs, commit .. "^")
  end
end

function M.completions(fargs)
  if vim.fn.isdirectory ".git/rebase-apply" == 1 or vim.fn.isdirectory ".git/rebase-merge" == 1 then
    if #fargs > 1 then
      return {}
    else
      return { "--abort", "--skip", "--continue" }
    end
  else
    return vim.list_extend({ "--interactive", "--autosquash" }, require("me.git.cache").short_branch)
  end
end

return M
