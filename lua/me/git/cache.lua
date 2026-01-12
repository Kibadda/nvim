local M = {}

local F = {}

function F.staged()
  return require("me.git.utils").run({ "diff" }, { "--cached", "--name-only" })
end

function F.unstaged()
  local files = {}

  for _, file in ipairs(require("me.git.utils").run({ "diff" }, { "--name-only" })) do
    files[file] = true
  end

  for _, file in ipairs(require("me.git.utils").run({ "ls-files" }, { "--others", "--exclude-standard" })) do
    files[file] = true
  end

  return vim.tbl_keys(files)
end

local function format_branches(sub)
  local branches = {}

  for _, branch in ipairs(require("me.git.utils").run({ "branch" }, { "--column=plain" })) do
    if not branch:find "HEAD" and branch ~= "" then
      branch = vim.trim(branch:gsub("*", ""):gsub(sub, ""))
    end

    branches[branch] = true
  end

  return vim.tbl_keys(branches)
end

function F.full_branch()
  return format_branches "remotes/"
end

function F.short_branch()
  return format_branches "remotes/[^/]+/"
end

function F.stashes()
  local stashes = {}

  for _, stash in ipairs(require("me.git.utils").run({ "stash" }, { "list" })) do
    table.insert(stashes, stash:match "^(stash@{%d+})")
  end

  return stashes
end

setmetatable(M, {
  __index = function(self, key)
    if F[key] then
      rawset(self, key, F[key]())
    end

    return rawget(self, key)
  end,
})

vim.api.nvim_create_autocmd("CmdlineLeave", {
  group = vim.api.nvim_create_augroup("GitCache", { clear = true }),
  callback = function()
    for key in pairs(M) do
      M[key] = nil
    end
  end,
})

return M
