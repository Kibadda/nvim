local M = {
  cmd = { "status", "--porcelain" },
  can_refresh = true,
  show_output_in_buffer = true,
}

--- @type { lines: string[], section: { file: string, section: string }[] }
local data = {}

M.lsp = {
  [vim.lsp.protocol.Methods.textDocument_codeLens] = function()
    local lenses = {}

    local function lens(opts)
      local files = opts.file and { opts.file } or nil
      if not files then
        files = {}
        local i = opts.i + 1
        while true do
          if not data.section[i] or not data.section[i].file then
            break
          end

          table.insert(files, data.section[i].file)
          i = i + 1
        end
      end

      table.insert(lenses, {
        range = {
          start = { line = opts.i - 1, character = 0 },
          ["end"] = { line = opts.i, character = 0 },
        },
        command = {
          title = opts.title,
          command = opts.command or opts.title,
          arguments = vim.tbl_extend("force", {
            files = files,
          }, opts.arguments or {}),
        },
      })
    end

    for i, d in ipairs(data.section) do
      if d.section == "untracked" then
        lens { title = "add", i = i, file = d.file }
        lens { title = "delete", i = i, file = d.file }
      elseif d.section == "unstaged" then
        lens { title = "add", i = i, file = d.file }
        lens { title = "edit", command = "add", arguments = { edit = true }, i = i, file = d.file }
        lens { title = "restore", i = i, file = d.file }
      elseif d.section == "staged" then
        lens { title = "restore", arguments = { staged = true }, i = i, file = d.file }
      elseif d.section == "unmerged" then
        lens { title = "add", i = i, file = d.file }
      end
    end

    return lenses
  end,

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
      action "delete"
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

    local s = data.section[params.position.line + 1]
    local cmd = {}

    if s.section == "staged" then
      table.insert(cmd, "--cached")
    end

    if s.file then
      table.insert(cmd, s.file)
    else
      local i = params.position.line + 2
      while true do
        if not data.section[i] or not data.section[i].file then
          break
        end

        table.insert(cmd, data.section[i].file)
        i = i + 1
      end
    end

    require("me.git.commands").diff:run(cmd)
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
      table.insert(section.untracked, { file = file, section = "untracked" })
    elseif prefix == " M" or prefix == " A" or prefix == " D" then
      table.insert(section.unstaged, { file = file, section = "unstaged" })
    elseif prefix == "M " or prefix == "A " or prefix == "D " or prefix == "R " then
      table.insert(section.staged, { file = file, section = "staged" })
    elseif prefix == "MM" or prefix == "AM" or prefix == "MD" or prefix == "AD" or prefix == "RM" then
      table.insert(section.staged, { file = file, section = "staged" })
      table.insert(section.unstaged, { file = file, section = "unstaged" })
    elseif prefix == "UU" or prefix == "AA" then
      table.insert(section.unmerged, { file = file, section = "unmerged" })
    else
      error(line)
    end
  end

  local extmarks = {}

  local function add_lines(type)
    if #section[type] > 0 then
      table.insert(data.lines, type:upper())
      data.section[#data.lines] = { section = type }
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
