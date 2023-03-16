local M = {}

function M.detach_from_tmux()
  os.execute "tmux detach"
end

function M.save_and_source()
  vim.cmd.w()

  if vim.bo.filetype == "lua" then
    vim.cmd.luafile "%"
  elseif vim.bo.filetype == "vim" then
    vim.cmd.source "%"
  end
end

function M.open_in_github()
  local Job = require "plenary.job"
  local job1 = Job:new {
    command = "git",
    args = {
      "remote",
    },
    cwd = vim.fn.getcwd(),
  }
  job1:sync()
  local remote = job1:result()[1]
  local job2 = Job:new {
    command = "git",
    args = {
      "config",
      "--get",
      ("remote.%s.url"):format(remote),
    },
    cwd = vim.fn.getcwd(),
  }
  job2:sync()
  local remote_url = job2:result()[1]
  remote_url = string.gsub(remote_url, "%.git", "")
  remote_url = string.gsub(remote_url, ":", "/")
  remote_url = string.gsub(remote_url, "git@", "https://")
  os.execute(("xdg-open %s"):format(remote_url))
end

function M.jump_direction(direction)
  return function()
    local count = vim.v.count

    if count == 0 then
      vim.cmd.normal { ("g%s"):format(direction), bang = true }
      return
    end

    if count > 5 then
      vim.cmd.normal { "m'", bang = true }
    end

    vim.cmd.normal { ("%d%s"):format(count, direction), bang = true }
  end
end

function M.is_work()
  return string.find(vim.fn.getcwd(), "^/media/")
end

function M.open_url()
  os.execute("xdg-open " .. vim.fn.expand "<cWORD>")
end

function M.new_scratch()
  vim.ui.input({
    prompt = "Filename: ",
  }, function(input)
    if input and input ~= "" then
      vim.cmd(("e %s/%s.lua"):format(vim.fn.stdpath "config" .. "/scratch", input))
    end
  end)
end

function M.load_extra_keymaps()
  local files = vim.fs.find(".nvim-keymaps.lua", {
    type = "file",
    path = vim.loop.cwd(),
  })

  if #files == 0 then
    return
  end

  vim.cmd.luafile(files[1])
end

function M.set_global_options(options, prefix)
  prefix = prefix and prefix .. "_" or ""
  for option_name, option_value in pairs(options) do
    vim.g[("%s%s"):format(prefix, option_name)] = option_value
  end
end

return M
