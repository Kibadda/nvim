local M = {}

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

function M.set_global_options(options, prefix)
  prefix = prefix and prefix .. "_" or ""
  for option_name, option_value in pairs(options) do
    vim.g[("%s%s"):format(prefix, option_name)] = option_value
  end
end

function M.keymaps(options)
  for opts, keymaps in pairs(options) do
    if type(opts) ~= "table" then
      opts = { mode = opts }
    end
    if not pcall(require, "which-key") then
      print "why is this not loaded"
    else
      require("which-key").register(keymaps, opts)
    end
  end
end

return M
