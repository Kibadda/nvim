local M = {
  cmd = { "status", "--porcelain" },
  can_refresh = true,
  show_output_in_buffer = true,
}

local data = {}

M.lsp = {
  [vim.lsp.protocol.Methods.textDocument_codeAction] = function(params)
    --- @cast params lsp.CodeActionParams

    local files = {}
    local section

    if
      params.range.start.line == params.range["end"].line
      and type(data.section[params.range.start.line + 1]) == "string"
    then
      section = string.lower(data.section[params.range.start.line + 1])
    else
      for i = params.range.start.line + 1, params.range["end"].line + 1 do
        if type(data.section[i]) ~= "table" then
          return {}
        end

        table.insert(files, data.section[i].file)
        section = data.section[i].section
      end
    end

    local codeactions = {}

    local function action(title, opts)
      opts = opts or {}
      table.insert(codeactions, {
        title = title,
        command = {
          title = title,
          command = opts.command or title,
          arguments = vim.tbl_extend("force", {
            files = files,
            bufnr = M.bufnr,
          }, opts.arguments or {}),
        },
      })
    end

    if section == "untracked" then
      action "add"
    elseif section == "unstaged" then
      action "add"
      action("add --edit", { command = "add", arguments = { edit = true } })
      action "restore"
      action "diff"
    elseif section == "staged" then
      action("restore --staged", { command = "restore", arguments = { staged = true } })
      action("diff", { arguments = { cached = true } })
    elseif section == "unmerged" then
      action "add"
    end

    return codeactions
  end,

  [vim.lsp.protocol.Methods.textDocument_hover] = function(params)
    --- @cast params lsp.HoverParams

    if type(data.section[params.position.line + 1]) == "table" then
      require("me.git.commands").diff:run(
        vim.list_extend(
          data.section[params.position.line + 1].section == "staged" and { "--cached" } or {},
          { data.section[params.position.line + 1].file }
        )
      )
    elseif data.section[params.position.line + 1] == "STAGED" then
      require("me.git.commands").diff:run { "--cached" }
    elseif data.section[params.position.line + 1] == "UNSTAGED" then
      require("me.git.commands").diff:run {}
    end
  end,
}

function M:on_buf_load(stdout)
  data = {
    section = {},
    lines = {},
  }

  local section = {
    staged = {},
    unstaged = {},
    untracked = {},
    unmerged = {},
  }

  for _, line in ipairs(stdout) do
    local prefix = line:sub(1, 2)
    local file = line:sub(4)

    if prefix == "??" then
      table.insert(section.untracked, { file = file, prefix = prefix, section = "untracked" })
    elseif prefix == " M" or prefix == " D" then
      table.insert(section.unstaged, { file = file, prefix = prefix, section = "unstaged" })
    elseif prefix == "M " or prefix == "A " or prefix == "D " or prefix == "R " then
      table.insert(section.staged, { file = file, prefix = prefix, section = "staged" })
    elseif prefix == "MM" or prefix == "AM" or prefix == "MD" then
      table.insert(section.staged, { file = file, prefix = prefix, section = "staged" })
      table.insert(section.unstaged, { file = file, prefix = prefix, section = "unstaged" })
    elseif prefix == "UU" then
      table.insert(section.unmerged, { file = file, prefix = prefix, section = "unmerged" })
    else
      error(line)
    end
  end

  local extmarks = {}

  local function add_lines(type)
    if #section[type] > 0 then
      table.insert(data.lines, type:upper())
      data.section[#data.lines] = type:upper()
      table.insert(extmarks, {
        line = #data.lines,
        col = 1,
        end_col = #data.lines[#data.lines],
        hl = "@keyword",
      })
      for _, s in ipairs(section[type]) do
        table.insert(data.lines, "  " .. s.file)
        data.section[#data.lines] = s
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
      {
        lhs = "<C-Cr>",
        rhs = function()
          local row = vim.api.nvim_win_get_cursor(0)[1]
          local line = vim.api.nvim_buf_get_lines(0, row - 1, row, false)[1]
          vim.api.nvim_buf_delete(self.bufnr, { force = true })
          vim.cmd.edit(vim.trim(line))
        end,
      },
    },
  }
end

return M
