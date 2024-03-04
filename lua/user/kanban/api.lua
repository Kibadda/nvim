local M = {}

local curl = require "plenary.curl"

local function request(method, url)
  return curl.request {
    method = method,
    url = url,
    headers = {
      ["PRIVATE-TOKEN"] = vim.env.GITLAB_ACCESS_TOKEN,
    },
  }
end

---@param str string
local function urlencode(str)
  str = str:gsub("\n", "\r\n")
  str = str:gsub("([^%wäöüß %-%_%.%~])", function(c)
    return ("%%02X"):format(c:byte())
  end)
  str = str:gsub(" ", "+")

  return str
end

function M.issues()
  local max = 100
  local page = 1
  local all = {}
  local count

  repeat
    local response = request("get", vim.env.GITLAB_PROJECT_URL .. "issues?per_page=" .. max .. "&page=" .. page)

    if not response or response.status ~= 200 then
      break
    end

    local issues = vim.json.decode(response.body)

    if not issues then
      break
    end

    count = vim.tbl_count(issues)
    page = page + 1

    vim.list_extend(all, issues)
  until count < max

  return all
end

function M.create(opts)
  if not opts.title or #opts.title == 0 then
    return
  end

  local query = {
    "title=" .. urlencode(opts.title),
  }

  if opts.description then
    table.insert(query, "description=" .. urlencode(opts.description))
  end

  if opts.labels and #opts.labels > 0 then
    for k, v in ipairs(opts.labels) do
      opts[k] = urlencode(v)
    end

    table.insert(query, "labels=" .. table.concat(opts.labels, ","))
  end

  return request("post", vim.env.GITLAB_PROJECT_URL .. "issues?" .. table.concat(query, "&"))
end

function M.update(issue, opts)
  local query = {}

  if opts.labels and #opts.labels > 0 then
    for k, v in ipairs(opts.labels) do
      opts[k] = urlencode(v)
    end

    table.insert(query, "labels=" .. table.concat(opts.labels, ","))
  end

  if opts.closed ~= nil then
    table.insert(query, "state_event=" .. (opts.closed and "close" or "reopen"))
  end

  if opts.title then
    table.insert(query, "title=" .. urlencode(opts.title))
  end

  if #query == 0 then
    return
  end

  return request("put", issue.api_url .. "?" .. table.concat(query, "&"))
end

function M.delete(issue)
  return request("delete", issue.api_url)
end

function M.labels()
  local response = request("get", vim.env.GITLAB_PROJECT_URL .. "labels?per_page=100")

  if not response or response.status ~= 200 then
    return {}
  end

  local labels = vim.json.decode(response.body)

  if not labels then
    return {}
  end

  vim.print(labels)

  return labels
end

function M.update_time(issue, time)
  time = time == "" and 0 or tonumber(time)

  if time == 0 then
    return request("post", issue.api_url .. "/reset_spent_time")
  end

  local diff = time - issue.time

  if diff == 0 then
    return
  end

  return request("post", issue.api_url .. "/add_spent_time?duration=" .. diff .. "m")
end

return M
