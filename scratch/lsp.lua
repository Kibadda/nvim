local ns = vim.api.nvim_create_namespace "inlay_hints"
local buffers = {}

local function set_inlay_hints(bufnr)
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

  local function_calls = {}
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
    table.insert(function_calls, call)
  end

  local uri = vim.uri_from_bufnr(bufnr)
  for _, call in ipairs(function_calls) do
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

      if
        result
        and result.signatures
        and result.signatures[1]
        and result.signatures[1].parameters
        and #result.signatures[1].parameters == #call.parameters
      then
        local text = result.signatures[1].label
        local parameters = result.signatures[1].parameters
        for i, parameter in ipairs(call.parameters) do
          local name = string.sub(text, parameters[i].label[1] + 1, parameters[i].label[2])

          local space = name:find " "
          if space then
            name = name:sub(1, space - 1)
          end

          local id = vim.api.nvim_buf_set_extmark(bufnr, ns, parameter[1], parameter[2], {
            virt_text = {
              { name, "@keyword" },
              { " ", "Normal" },
            },
            virt_text_pos = "inline",
          })

          buffers[bufnr] = buffers[bufnr] or {}
          table.insert(buffers[bufnr], id)
        end
      end
    end)
  end
end

local function clear_inlay_hints(bufnr)
  if buffers[bufnr] then
    for _, id in ipairs(buffers[bufnr]) do
      vim.api.nvim_buf_del_extmark(bufnr, ns, id)
    end
    buffers[bufnr] = nil
  end
end

local function setTimeout(timeout, callback)
  local timer = vim.loop.new_timer()
  if timer then
    timer:start(timeout, 0, function()
      timer:stop()
      timer:close()
      callback()
    end)
  end
  return timer
end

local function clearTimeout(timer)
  if timer then
    timer:stop()
    timer:close()
  end
end

local group = vim.api.nvim_create_augroup("InlayHints", { clear = true })
vim.api.nvim_create_autocmd({ "BufEnter" }, {
  group = group,
  pattern = "*.lua",
  callback = function(args)
    if not buffers[args.buf] then
      set_inlay_hints(args.buf)
    end

    vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI" }, {
      buffer = args.buf,
      callback = function()
        -- if timer then
        --   clearTimeout(timer)

        -- end

        -- timer = setTimeout(2000, function()
        --   vim.schedule_wrap(function()
        clear_inlay_hints(args.buf)
        set_inlay_hints(args.buf)
        --   end)
        -- end)
      end,
    })
  end,
})
