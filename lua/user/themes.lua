local M = {}

M.current = nil

local themes = {}

function M.register(name, callback)
  if type(callback) == "function" then
    themes[name] = callback
  end
end

function M.apply(name)
  if themes[name] then
    themes[name]()

    -- FIX: this reloads heirline, otherwise it would just be white
    require("heirline").setup(require("user.plugins.heirline").opts())

    M.current = name
  end
end

function M.select()
  local t = vim.tbl_keys(themes)

  table.sort(t)

  vim.ui.select(t, {}, function(choice)
    if choice then
      M.apply(choice)
    end
  end)
end

return M
