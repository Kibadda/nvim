local M = {
  groups = {},
  mappings = {},
  current = nil,
  labels = {},
}

local config = {
  show_open = true,
  show_closed = true,
  groups = {
    "Montag",
    "Dienstag",
    "Mittwoch",
    "Donnerstag",
    "Freitag",
  },
}

local ns = vim.api.nvim_create_namespace "KanbanExtmarks"

local api = require "user.kanban.api"

local highlights = {
  Border = { name = "KanbanBorder", hl = { fg = vim.g.colors.white } },
  BorderWeek = { name = "KanbanBorderWeek", hl = { fg = vim.g.colors.cyan } },
  BorderCurrent = { name = "KanbanBorderCurrent", hl = { fg = vim.g.colors.red } },
  Title = { name = "KanbanTitle", hl = { fg = vim.g.colors.red } },
}

for _, hl in pairs(highlights) do
  vim.api.nvim_set_hl(0, hl.name, hl.hl)
end

local function create_group(data)
  local buf = vim.api.nvim_create_buf(false, true)

  local win = vim.api.nvim_open_win(buf, false, {
    relative = "editor",
    border = "single",
    title = " " .. data.name .. " ",
    title_pos = "center",
    height = data.height,
    width = data.width,
    row = 1,
    col = data.col,
  })

  vim.wo[win].signcolumn = "no"
  vim.wo[win].statuscolumn = nil
  vim.wo[win].number = false
  vim.wo[win].relativenumber = false
  vim.wo[win].cursorline = false
  vim.wo[win].fillchars = "eob: "
  vim.wo[win].wrap = true
  vim.wo[win].linebreak = true
  vim.wo[win].showbreak = "  "
  vim.wo[win].winhighlight = "FloatBorder:" .. data.border

  vim.bo[buf].modifiable = false

  local map = function(lhs, rhs, desc)
    vim.keymap.set("n", lhs, rhs, { buffer = buf, desc = desc })
  end

  map("gH", function()
    vim.ui.open(vim.env.GITLAB_BOARD_URL)
  end, "Open Board")

  map("q", function()
    require("user.kanban").close()
  end, "Close")

  map("h", function()
    vim.api.nvim_set_current_win(M.groups[data.i > 1 and data.i - 1 or #M.groups].win)
  end, "Focus Prev Group")

  map("l", function()
    vim.api.nvim_set_current_win(M.groups[data.i < #M.groups and data.i + 1 or 1].win)
  end, "Focus Next Group")

  map("j", function()
    local lines = M.groups[data.i].lines

    local row = vim.api.nvim_win_get_cursor(win)[1]

    for i = row + 1, #lines do
      if lines[i]:find "^ - " then
        vim.api.nvim_win_set_cursor(win, { i, 1 })
        break
      end
    end
  end, "Focus Next Issue")

  map("k", function()
    local lines = M.groups[data.i].lines

    local row = vim.api.nvim_win_get_cursor(win)[1]

    for i = row - 1, 1, -1 do
      if lines[i]:find "^ - " then
        vim.api.nvim_win_set_cursor(win, { i, 1 })
        break
      end
    end
  end, "Focus Previous Issue")

  map("c", function()
    require "user.kanban.form" {
      fields = {
        labels = {
          items = require("user.kanban.cache").get_labels(config),
        },
      },
      submit = function(result)
        if vim.tbl_contains(config.groups, data.name) then
          result.labels = result.labels or {}
          table.insert(result.labels, data.name)
        end

        api.create(result)

        vim.api.nvim_set_current_win(win)

        vim.schedule(function()
          M.issues(true)
        end)
      end,
      close = function()
        vim.api.nvim_set_current_win(win)
      end,
    }
  end)

  ---@param callback function
  local function with_issue(callback)
    return function()
      local row = vim.api.nvim_win_get_cursor(win)[1]

      local issue = M.groups[data.i].lines_to_issues[row]

      if issue then
        callback(issue)
      end
    end
  end

  map(
    "o",
    with_issue(function(issue)
      vim.ui.open(issue.web_url)
    end),
    "Open in Browser"
  )

  map(
    "e",
    with_issue(function(issue)
      require "user.kanban.form" {
        fields = {
          title = issue.title,
          description = issue.description,
          labels = {
            items = require("user.kanban.cache").get_labels(config),
            selected = {
              issue.project,
            },
          },
        },
        submit = function(result)
          if vim.tbl_contains(config.groups, data.name) then
            result.labels = result.labels or {}
            table.insert(result.labels, data.name)
          end

          api.update(issue, result)

          vim.api.nvim_set_current_win(win)

          vim.schedule(function()
            M.issues(true)
          end)
        end,
        close = function()
          vim.api.nvim_set_current_win(win)
        end,
      }
    end),
    "Edit Issue"
  )

  map(
    "d",
    with_issue(function(issue)
      if vim.fn.confirm("Delete issue '" .. issue.title .. "'?", "&Yes\n&No", 2) == 1 then
        api.delete(issue)

        vim.schedule(function()
          M.issues(true)
        end)
      end
    end),
    "Delete Issue"
  )

  map(
    "m",
    with_issue(function(issue)
      local groups = vim.deepcopy(config.groups)

      if config.show_open then
        table.insert(groups, 1, "Open")
      end
      if config.show_closed then
        table.insert(groups, "Closed")
      end

      vim.ui.select(groups, { prompt = "Move to:" }, function(choice)
        if not choice then
          return
        end

        local closed
        local labels = { issue.project }
        if choice == "Open" then
          closed = false
        elseif choice == "Closed" then
          closed = true
        else
          table.insert(labels, choice)
        end

        api.update(issue, { closed = closed, labels = labels })

        vim.schedule(function()
          M.issues(true)
        end)
      end)
    end),
    "Move"
  )

  map(
    "H",
    with_issue(function(issue)
      local n = data.i > 0 and data.i - 1 or #M.groups

      local opts = {
        closed = config.show_closed and n == #M.groups,
        labels = { issue.project },
      }

      if not ((config.show_open and n == 1) or (config.show_closed and n == #M.groups)) then
        table.insert(opts.labels, M.groups[n].name)
      end

      api.update(issue, opts)

      vim.schedule(function()
        M.issues(true)
      end)
    end),
    "Move to Previous Group"
  )

  map(
    "L",
    with_issue(function(issue)
      local n = data.i < #M.groups and data.i + 1 or 1

      local opts = {
        closed = config.show_closed and n == #M.groups,
        labels = { issue.project },
      }

      if not ((config.show_open and n == 1) or (config.show_closed and n == #M.groups)) then
        table.insert(opts.labels, M.groups[n].name)
      end

      api.update(issue, opts)

      vim.schedule(function()
        M.issues(true)
      end)
    end),
    "Move to Next Group"
  )

  return {
    win = win,
    buf = buf,
    name = data.name,
    lines_to_issues = {},
    lines = {},
  }
end

function M.create()
  local groups = vim.deepcopy(config.groups)

  if config.show_open then
    table.insert(groups, 1, "Open")
  end
  if config.show_closed then
    table.insert(groups, "Closed")
  end

  M.current = tonumber(os.date "%w") + (config.show_open and 1 or 0)

  local amount = #groups

  local height = vim.o.lines - 5
  local width = math.floor(vim.o.columns / amount)
  local remaining = vim.o.columns % amount

  for i, group in ipairs(groups) do
    local col_offset = 0
    local width_offset = 0
    if i >= amount - remaining + 1 then
      col_offset = (i - (amount - remaining + 1))
      width_offset = 1
    end

    local border = highlights.Border.name
    if i == M.current then
      border = highlights.BorderCurrent.name
    elseif vim.tbl_contains(config.groups, group) then
      border = highlights.BorderWeek.name
    end

    M.groups[i] = create_group {
      i = i,
      name = group,
      height = height,
      width = width + width_offset - 2,
      col = (i - 1) * width + col_offset,
      border = border,
    }

    M.mappings[group] = i
  end
end

function M.destroy()
  for _, group in pairs(M.groups) do
    vim.api.nvim_win_close(group.win, true)
  end
end

function M.remove()
  for _, group in pairs(M.groups) do
    for _, extmark in ipairs(vim.api.nvim_buf_get_extmarks(group.buf, ns, 0, -1, {})) do
      vim.api.nvim_buf_del_extmark(group.buf, ns, extmark[1])
    end

    vim.bo[group.buf].modifiable = true
    vim.api.nvim_buf_set_lines(group.buf, 0, -1, false, {})
    vim.bo[group.buf].modifiable = false
  end
end

function M.issues(ignore_cache)
  local cache = require "user.kanban.cache"

  if ignore_cache then
    M.remove()

    cache.issues = {}
  end

  local labels_per_group = {}

  local all_issues = cache.get_issues(config)

  for i, issue in ipairs(all_issues) do
    labels_per_group[issue.group] = labels_per_group[issue.group] or {}

    labels_per_group[issue.group][issue.project] = labels_per_group[issue.group][issue.project] or {}
    table.insert(labels_per_group[issue.group][issue.project], i)
  end

  for group_name, projects in pairs(labels_per_group) do
    if M.mappings[group_name] then
      local group = M.groups[M.mappings[group_name]]

      local lines = {}
      local extmarks = {}

      local p = vim.tbl_keys(projects)
      table.sort(p)

      for _, project in ipairs(p) do
        table.insert(lines, project)
        table.insert(extmarks, {
          line = #lines - 1,
          col = #project,
        })

        for _, i in ipairs(labels_per_group[group_name][project]) do
          table.insert(lines, " - " .. all_issues[i].title)
          group.lines_to_issues[#lines] = all_issues[i]
        end

        table.insert(lines, "")
      end

      group.lines = lines
      vim.bo[group.buf].modifiable = true
      vim.api.nvim_buf_set_lines(group.buf, 0, -1, false, lines)
      vim.bo[group.buf].modifiable = false

      if #lines > 0 then
        vim.api.nvim_win_set_cursor(group.win, { 2, 1 })
      end

      for _, extmark in ipairs(extmarks) do
        vim.api.nvim_buf_set_extmark(group.buf, ns, extmark.line, 0, {
          end_row = extmark.line,
          end_col = extmark.col,
          hl_group = highlights.Title.name,
        })
      end
    end
  end
end

return M
