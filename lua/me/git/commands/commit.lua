local M = {
  cmd = { "commit" },
}

M.lsp = {
  [vim.lsp.protocol.Methods.textDocument_codeAction] = function()
    return {
      {
        title = "show diff",
        command = {
          title = "show diff",
          command = "show_diff",
          arguments = {
            files = {},
            cached = true,
          },
        },
      },
    }
  end,

  [vim.lsp.protocol.Methods.textDocument_signatureHelp] = function()
    vim.cmd.stopinsert()

    require("me.git.commands").diff:run { "--cached" }
  end,

  [vim.lsp.protocol.Methods.textDocument_hover] = function()
    require("me.git.commands").diff:run { "--cached" }
  end,
}

function M:pre_run(fargs)
  if #fargs == 1 and fargs[1] == "--fixup" then
    local commit = require("me.git.utils").select_commit()

    if not commit then
      return false
    end

    table.insert(fargs, commit)
  end
end

function M.completions(fargs)
  if fargs[1] == "--fixup" then
    return {}
  elseif #fargs > 1 then
    return { "--amend", "--no-edit" }
  else
    return { "--amend", "--no-edit", "--fixup" }
  end
end

return M
