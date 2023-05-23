local timer = require "user.utils.timer"

local M = {
  buffers = {},
  timers = {},
}

vim.g.InlayHints = vim.g.InlayHints or 0

local Namespace = vim.api.nvim_create_namespace "inlay_hints"
local Augroup = vim.api.nvim_create_augroup("InlayHints", { clear = true })
local Highlight = "InlayHint"

vim.api.nvim_set_hl(0, Highlight .. "Underline", {
  fg = "#E8D4B0",
  underline = true,
})
vim.api.nvim_set_hl(0, Highlight, {
  fg = "#E8D4B0",
})

function M.toggle()
  vim.g.InlayHints = vim.g.InlayHints == 0 and 1 or 0
  vim.notify(vim.g.InlayHints == 1 and "Turned on" or "Turned off", vim.log.levels.INFO, { title = "Inlay Hints" })

  if vim.g.InlayHints == 0 then
    for bufnr in pairs(M.buffers) do
      M.clear_inlay_hints(bufnr)
    end
  end
end

function M.set_inlay_hints(bufnr)
  if vim.bo[bufnr].filetype ~= "lua" then
    return
  end

  M.clear_inlay_hints(bufnr)

  if vim.g.InlayHints == 0 then
    return
  end

  local root = vim.treesitter.get_parser(bufnr, "lua", {}):parse()[1]:root()
  local query = vim.treesitter.query.parse(
    "lua",
    [[
      (function_call
        name: [
          (identifier) @function
          (dot_index_expression
            field: (identifier) @function)
        ]
        arguments: (arguments) @parameters
      )
    ]]
  )

  local calls = {}
  for _, match in query:iter_matches(root, bufnr, 0, -1) do
    local call = {
      fun = {},
      parameters = {},
    }
    for id, node in pairs(match) do
      if query.captures[id] == "function" then
        call.fun = { node:range() }
      elseif query.captures[id] == "parameters" then
        for child in node:iter_children() do
          if vim.treesitter.get_node_text(child, bufnr) ~= child:type() then
            table.insert(call.parameters, { child:range() })
          end
        end
      end
    end
    table.insert(calls, call)
  end

  local uri = vim.uri_from_bufnr(bufnr)
  for _, call in ipairs(calls) do
    local params = {
      position = {
        line = call.fun[1],
        character = call.fun[2],
      },
      textDocument = {
        uri = uri,
      },
    }

    vim.lsp.buf_request(bufnr, "textDocument/signatureHelp", params, function(err, result)
      if err then
        return
      end

      if result and result.signatures and result.signatures[1] and result.signatures[1].parameters then
        local text = result.signatures[1].label
        local parameters = result.signatures[1].parameters
        for i = 1, math.min(#parameters, #call.parameters) do
          local name = string.sub(text, parameters[i].label[1] + 1, parameters[i].label[2])

          local space = name:find ":"
          if space then
            name = name:sub(1, space - 1)
          end

          local id = vim.api.nvim_buf_set_extmark(bufnr, Namespace, call.parameters[i][1], call.parameters[i][2], {
            virt_text = {
              { name, Highlight .. "Underline" },
              { ":", Highlight },
              { " ", "Normal" },
            },
            virt_text_pos = "inline",
          })

          M.buffers[bufnr] = M.buffers[bufnr] or {}
          table.insert(M.buffers[bufnr], 1, id)
        end
      end
    end)
  end
end

function M.clear_inlay_hints(bufnr)
  if M.buffers[bufnr] then
    for _, id in ipairs(M.buffers[bufnr]) do
      vim.api.nvim_buf_del_extmark(bufnr, Namespace, id)
    end
    M.buffers[bufnr] = nil
  end
end

function M.setup(client, bufnr)
  if vim.g.InlayHints == 1 then
    M.set_inlay_hints(bufnr)
  end

  vim.api.nvim_clear_autocmds {
    group = Augroup,
    buffer = bufnr,
  }

  vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI" }, {
    group = Augroup,
    buffer = bufnr,
    callback = function()
      if M.timers[bufnr] then
        timer.clear(M.timers[bufnr])
      end

      M.timers[bufnr] = timer.timeout(
        2000,
        vim.schedule_wrap(function()
          M.set_inlay_hints(bufnr)
        end)
      )
    end,
  })

  require("user.utils").keymaps {
    [{ mode = "n", buffer = bufnr }] = {
      ["<Leader>"] = {
        l = {
          i = { M.toggle, "Toggle Inlay Hints" },
        },
      },
    },
  }
end

return M
