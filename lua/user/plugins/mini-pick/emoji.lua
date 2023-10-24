return function()
  local results = require "user.data.emoji"

  for _, r in ipairs(results) do
    r.text = r[1] .. " " .. r[2]
  end

  local buf = vim.api.nvim_get_current_buf()
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))

  MiniPick.start {
    source = {
      name = "Emoji",
      items = results,
      show = function(buf_id, items, query)
        MiniPick.default_show(buf_id, items, query, { show_icons = true })
      end,
      choose = function(item)
        vim.api.nvim_buf_set_text(buf, row - 1, col, row - 1, col, { item[1] })
      end,
    },
  }
end
