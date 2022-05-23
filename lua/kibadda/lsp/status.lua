local ok, nvim_status = pcall(require, "lsp-status")
if not ok then
  return false
end

local status = {}

status.select_symbol = function (cursor_pos, symbol)
  if symbol.valueRange then
    local value_range = {
      ["start"] = {
        character = 0,
        line = vim.fn.byte2line(symbol.valueRange[1]),
      },
      ["end"] = {
        character = 0,
        line = vim.fn.byte2line(symbol.valueRange[2]),
      },
    }

    return require("lsp-status.util").in_range(cursor_pos, value_range)
  end
end

status.activate = function ()
  nvim_status.config {
    select_symbol = status.select_symbol,

    indicator_errors = "",
    indicator_warnings = "",
    indicator_info = "🛈",
    indicator_hint = "!",
    indicator_ok = "",
    spinner_frames = { "⣾", "⣽", "⣻", "⢿", "⡿", "⣟", "⣯", "⣷" },
  }

  nvim_status.register_progress()
end

status.on_attach = function (client)
  nvim_status.on_attach(client)

  local KibaddaLspStatusGroup = vim.api.nvim_create_augroup('KibaddaLspStatusGroup', { clear = true })
  vim.api.nvim_create_autocmd({ "CursorHold", "BufEnter", }, {
    group = KibaddaLspStatusGroup,
    pattern = "<buffer>",
    callback = function ()
      require("lsp-status").update_current_function()
    end,
  })
end

return status
