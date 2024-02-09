-- TODO move to own tab
-- TODO show opened and closed issues on left and right
-- TODO add function to move issues
-- TODO add function to close issue
-- TODO add function to create new issue
-- TODO add function to delete issue

if vim.g.loaded_todos or vim.env.LOCATION ~= "work" then
  return
end

vim.g.loaded_todos = 1

local guicursor = vim.opt.guicursor:get()
local filled = false
local week = {
  Montag = {},
  Dienstag = {},
  Mittwoch = {},
  Donnerstag = {},
  Freitag = {},
}
local wins = {}
local weekdays = { "Montag", "Dienstag", "Mittwoch", "Donnerstag", "Freitag" }
local shown = false

local function close()
  for _, win in pairs(wins) do
    vim.api.nvim_win_close(win, true)
  end
  vim.cmd.highlight "Cursor blend=0"
  vim.opt.guicursor = guicursor
  shown = false
end

local function get_todos()
  if filled then
    return
  end

  local curl = require "plenary.curl"

  local response = curl.get(vim.env.GITLAB_PROJECT_URL, {
    headers = {
      ["PRIVATE-TOKEN"] = vim.env.GITLAB_ACCESS_TOKEN,
    },
  })

  if response and response.status == 200 then
    local issues = vim.json.decode(response.body)

    if issues then
      for _, issue in ipairs(issues) do
        if
          vim.iter(issue.labels):any(function(label)
            return vim.tbl_contains(vim.tbl_keys(week), label)
          end)
        then
          local weekday
          local project = "Cortex"

          for _, label in ipairs(issue.labels) do
            if week[label] then
              weekday = label
            else
              project = label
            end
          end

          week[weekday][project] = week[weekday][project] or {}
          table.insert(week[weekday][project], issue.title)
        end
      end

      filled = true
    end
  end
end

local function open_todos()
  local width = math.floor(vim.o.columns * 0.65)
  local height = math.floor(vim.o.lines * 0.65)

  local weekday = tonumber(os.date "%w")

  for i, name in ipairs(weekdays) do
    local ns = vim.api.nvim_create_namespace("todos" .. name)
    local buf = vim.api.nvim_create_buf(false, true)
    local win = vim.api.nvim_open_win(buf, false, {
      relative = "editor",
      border = "single",
      title = " " .. name .. " ",
      title_pos = "center",
      height = height,
      width = math.floor(width / 5 - 2),
      row = (vim.o.lines - height) / 2,
      col = (vim.o.columns - width) / 2 + math.floor(width * (i - 1) / 5) + 1,
    })

    vim.wo[win].signcolumn = "no"
    vim.wo[win].statuscolumn = nil
    vim.wo[win].number = false
    vim.wo[win].relativenumber = false
    vim.wo[win].cursorline = false
    vim.wo[win].fillchars = "eob: "
    vim.wo[win].wrap = true
    vim.wo[win].linebreak = true
    vim.wo[win].showbreak = "   "
    if i == weekday then
      vim.wo[win].winhighlight = "FloatBorder:TodosBorder"
    else
      vim.wo[win].winhighlight = "FloatBorder:TodosBorderNC"
    end

    vim.keymap.set("n", "q", close, { buffer = buf })
    vim.keymap.set("n", "<Esc>", close, { buffer = buf })

    local projects = vim.tbl_keys(week[name])
    table.sort(projects)

    local lines = {}
    local extmarks = {}

    for _, project in ipairs(projects) do
      local todos = week[name][project]
      table.sort(todos)

      table.insert(lines, project)

      table.insert(extmarks, {
        line = #lines - 1,
        col = #project,
      })

      for _, todo in ipairs(todos) do
        table.insert(lines, " - " .. todo)
      end

      table.insert(lines, "")
    end

    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

    for _, extmark in ipairs(extmarks) do
      vim.api.nvim_buf_set_extmark(buf, ns, extmark.line, 0, {
        end_row = extmark.line,
        end_col = extmark.col,
        hl_group = "Keyword",
      })
    end

    wins[name] = win
  end

  vim.cmd.highlight "Cursor blend=100"
  vim.opt.guicursor = "a:Cursor/lCursor"
  vim.api.nvim_set_current_win(wins[weekdays[weekday]])

  shown = true
end

vim.api.nvim_create_autocmd("VimResized", {
  group = vim.api.nvim_create_augroup("TodoResize", { clear = true }),
  callback = function()
    local width = math.floor(vim.o.columns * 0.65)
    local height = math.floor(vim.o.lines * 0.65)

    for i, name in ipairs(weekdays) do
      vim.api.nvim_win_set_config(wins[name], {
        relative = "editor",
        height = height,
        width = math.floor(width / 5 - 2),
        row = (vim.o.lines - height) / 2,
        col = (vim.o.columns - width) / 2 + math.floor(width * (i - 1) / 5) + 1,
      })
    end
  end,
})

vim.api.nvim_create_user_command("Todos", function(args)
  if vim.trim(args.args) == "clear" then
    filled = false
    for _, name in ipairs(vim.tbl_keys(week)) do
      week[name] = {}
    end
  else
    if shown then
      close()
    end

    get_todos()
    open_todos()
  end
end, { bang = false, bar = false, nargs = "?" })

vim.keymap.set("n", "<Leader>t", "<Cmd>Todos<CR>", { desc = "Todos" })

vim.api.nvim_set_hl(0, "TodosBorder", { fg = vim.g.colors.red })
vim.api.nvim_set_hl(0, "TodosBorderNC", { fg = vim.g.colors.cyan })
