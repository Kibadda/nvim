local M = {
  cmd = { "status", "--porcelain" },
  can_refresh = true,
  show_output_in_buffer = true,
}

local data = {}

M.lsp = {
  [vim.lsp.protocol.Methods.textDocument_codeAction] = function(params)
    ---@cast params lsp.CodeActionParams

    local files = {}
    local action

    for i = params.range.start.line + 1, params.range["end"].line + 1 do
      if type(data.status[i]) ~= "table" then
        return {}
      end

      table.insert(files, data.status[i].file)
      action = data.status[i].action
    end

    local codeactions = {
      {
        title = action,
        command = {
          title = action,
          command = action,
          arguments = {
            files = files,
            bufnr = M.bufnr,
          },
        },
      },
    }

    if action == "add" then
      table.insert(codeactions, {
        title = "add --edit",
        command = {
          title = "add --edit",
          command = "add",
          arguments = {
            files = files,
            bufnr = M.bufnr,
            edit = true,
          },
        },
      })
    end

    table.insert(codeactions, {
      title = "show diff",
      command = {
        title = "show diff",
        command = "show_diff",
        arguments = {
          files = files,
          cached = action == "unstage",
        },
      },
    })

    return codeactions
  end,

  [vim.lsp.protocol.Methods.textDocument_hover] = function(params)
    --- @cast params lsp.HoverParams

    if type(data.status[params.position.line + 1]) == "table" then
      require("me.git.commands").diff:run(
        vim.list_extend(
          data.status[params.position.line + 1].action == "unstage" and { "--cached" } or {},
          { data.status[params.position.line + 1].file }
        )
      )
    elseif data.status[params.position.line + 1] == "STAGED" then
      require("me.git.commands").diff:run { "--cached" }
    elseif data.status[params.position.line + 1] == "UNSTAGED" then
      require("me.git.commands").diff:run {}
    end
  end,
}

function M:on_buf_load(stdout)
  data = {
    status = {},
    lines = {},
  }

  local status = {
    staged = {},
    unstaged = {},
    untracked = {},
    unmerged = {},
  }

  for _, line in ipairs(stdout) do
    local prefix = line:sub(1, 2)
    local file = line:sub(4)

    if prefix == "??" then
      table.insert(status.untracked, { file = file, prefix = prefix, action = "add" })
    elseif prefix == " M" or prefix == " D" then
      table.insert(status.unstaged, { file = file, prefix = prefix, action = "add" })
    elseif prefix == "M " or prefix == "A " or prefix == "D " or prefix == "R " then
      table.insert(status.staged, { file = file, prefix = prefix, action = "unstage" })
    elseif prefix == "MM" or prefix == "AM" or prefix == "MD" then
      table.insert(status.staged, { file = file, prefix = prefix, action = "unstage" })
      table.insert(status.unstaged, { file = file, prefix = prefix, action = "add" })
    elseif prefix == "UU" then
      table.insert(status.unmerged, { file = file, prefix = prefix, action = "merge" })
    else
      error(prefix .. " " .. file)
    end
  end

  local extmarks = {}

  local function add_lines(type)
    if #status[type] > 0 then
      table.insert(data.lines, type:upper())
      data.status[#data.lines] = type:upper()
      table.insert(extmarks, {
        line = #data.lines,
        col = 1,
        end_col = #data.lines[#data.lines],
        hl = "@keyword",
      })
      for _, s in ipairs(status[type]) do
        table.insert(data.lines, "  " .. s.file)
        data.status[#data.lines] = s
      end
    end
  end

  add_lines "staged"
  add_lines "unstaged"
  add_lines "untracked"
  add_lines "unmerged"

  return {
    lines = data.lines,
    extmarks = extmarks,
    keymaps = {
      {
        lhs = "<Cr>",
        rhs = function()
          local row = vim.api.nvim_win_get_cursor(0)[1]
          local line = vim.api.nvim_buf_get_lines(0, row - 1, row, false)[1]
          vim.cmd.wincmd "w"
          vim.cmd.edit(vim.trim(line))
        end,
      },
    },
  }
end

return M
