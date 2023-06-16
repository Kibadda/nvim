local usercmd = vim.api.nvim_create_user_command

usercmd("D", function(argument)
  vim.cmd.BufferLineCyclePrev()
  if vim.fn.expand("#"):sub(1, 8) ~= "fugitive" then
    vim.cmd.split()
    vim.cmd.BufferLineCycleNext()
    vim.cmd.bdelete { bang = argument.bang }
  end
  vim.cmd.redrawt()
end, {
  bang = true,
  nargs = 0,
  desc = "Bdelete",
})

usercmd("X", function()
  vim.cmd.w()

  if vim.bo.filetype == "lua" then
    vim.cmd.luafile "%"
  elseif vim.bo.filetype == "vim" then
    vim.cmd.source "%"
  end
end, {
  bang = false,
  nargs = 0,
  desc = "Save and source",
})

usercmd("OpenGitInBrowser", function()
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
  if vim.startswith(remote_url, "git") then
    remote_url = string.gsub(remote_url, "%.git", "")
    remote_url = string.gsub(remote_url, ":", "/")
    remote_url = string.gsub(remote_url, "git@", "https://")
  end
  vim.system { "xdg-open", remote_url }
end, {
  bang = false,
  nargs = 0,
  desc = "Open current git project in browser",
})

usercmd("Info", function()
  local curl = require "plenary.curl"
  local response = curl.get "de.wttr.in/Ulm?T"
  if response and response.status == 200 then
    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_lines(buf, 1, -1, false, vim.split(response.body, "\n"))
    vim.bo[buf].readonly = true
    vim.bo[buf].modifiable = false
    vim.keymap.set("n", "q", function()
      vim.cmd.bwipeout()
    end, { buffer = buf })
    local win = vim.api.nvim_open_win(buf, true, {
      relative = "editor",
      border = "single",
      title = "Weather",
      title_pos = "center",
      row = 5,
      col = 25,
      height = vim.api.nvim_win_get_height(0) - 10,
      width = vim.api.nvim_win_get_width(0) - 50,
      style = "minimal",
    })
    vim.api.nvim_create_autocmd("BufLeave", {
      group = vim.api.nvim_create_augroup("CloseInfoWindow", { clear = true }),
      buffer = buf,
      once = true,
      callback = function()
        vim.cmd.bwipeout()
      end,
    })
    vim.api.nvim_set_current_win(win)
    vim.api.nvim_win_set_buf(win, buf)
  end
end, {
  bang = false,
  nargs = 0,
  desc = "Show information",
})

usercmd("ScratchList", function()
  local directory = vim.fn.stdpath "config" .. "/scratch"

  local function search_files(dir, prefix)
    local files = {}
    for name, type in vim.fs.dir(dir) do
      if type == "directory" then
        vim.list_extend(files, search_files(dir .. "/" .. name, name .. "/"))
      else
        table.insert(files, (prefix or "") .. name)
      end
    end

    return files
  end

  local files = search_files(directory)

  table.insert(files, 1, "New File")

  vim.ui.select(files, {}, function(choice, id)
    if not choice then
      return
    end

    if id == 1 then
      vim.ui.input({
        prompt = "Name: ",
      }, function(input)
        if input then
          vim.cmd(("e %s/%s.lua"):format(directory, input))
        end
      end)
    else
      vim.cmd(("e %s/%s"):format(directory, choice))
    end
  end)
end, {
  bang = false,
  nargs = 0,
  desc = "Open plugin list",
})

usercmd("PluginList", function()
  local directory = vim.fn.stdpath "config" .. "/lua/user/plugins"

  local function search_files(dir, prefix)
    local files = {}
    for name, type in vim.fs.dir(dir) do
      if type == "directory" then
        vim.list_extend(files, search_files(dir .. "/" .. name, name .. "/"))
      else
        table.insert(files, (prefix or "") .. name)
      end
    end

    return files
  end

  local files = search_files(directory)

  table.insert(files, 1, "New File")

  vim.ui.select(files, {}, function(choice, id)
    if not choice then
      return
    end

    if id == 1 then
      vim.ui.input({
        prompt = "Name: ",
      }, function(input)
        if input then
          vim.cmd(("e %s/%s.lua"):format(directory, input))
        end
      end)
    else
      vim.cmd(("e %s/%s"):format(directory, choice))
    end
  end)
end, {
  bang = false,
  nargs = 0,
  desc = "Open plugin list",
})

usercmd("PluginOpen", function()
  local root = vim.treesitter.get_parser(0, "lua", {}):parse()[1]:root()
  local query = vim.treesitter.query.parse(
    "lua",
    [[
      (return_statement
        (expression_list
          (table_constructor
            [
              (field
                !name
                value: (string) @plugin)
              (field
                name: (identifier) @dependencies (#eq? @dependencies "dependencies")
                value: (table_constructor
                  [
                    (field
                      !name
                      value: (string) @plugin)
                    (field
                      !name
                      value: (table_constructor
                        (field
                          !name
                          value: (string) @plugin)))
                  ]))
            ])))
    ]]
  )

  local plugins = {}
  for _, match in query:iter_matches(root, 0, 0, -1) do
    for id, node in pairs(match) do
      if query.captures[id] == "plugin" then
        local text = vim.treesitter.get_node_text(node, 0)
        if text then
          plugins[#plugins + 1] = text:gsub('"', "")
        end
      end
    end
  end

  if #plugins == 0 then
    return
  end

  local function open(plugin)
    vim.system { "xdg-open", ("https://github.com/%s"):format(plugin) }
  end

  if #plugins == 1 then
    open(plugins[1])
  else
    vim.ui.select(plugins, {
      prompt = "Select plugin to open",
    }, function(choice)
      if choice then
        open(choice)
      end
    end)
  end
end, {
  bang = false,
  nargs = 0,
  desc = "Open plugin in browser",
})
