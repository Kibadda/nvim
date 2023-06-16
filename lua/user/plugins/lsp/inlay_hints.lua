local M = {}

local group = vim.api.nvim_create_augroup("InlayHint", { clear = true })

local namespaces = setmetatable({}, {
  __index = function(t, key)
    local value = vim.api.nvim_create_namespace("vim_lsp_inlayhint:" .. key)
    rawset(t, key, value)
    return value
  end,
})

M.__namespaces = namespaces

vim.g.InlayHints = vim.g.InlayHints or 0

---@class InlayHintConfig
local options = {
  padding = true,
  highlights = {
    hint = {
      name = "LspInlayHint",
      value = { fg = "#E8D4B0", italic = true },
    },
    padding = {
      name = "LspInlayHintPadding",
      value = { link = "Normal" },
    },
  },
}

local function set_highlights()
  for _, highlight in pairs(options.highlights) do
    vim.api.nvim_set_hl(0, highlight.name, highlight.value)
  end
end

local function handler(err, result, ctx)
  vim.api.nvim_buf_clear_namespace(ctx.bufnr, namespaces[ctx.client_id], 0, -1)

  if err or vim.g.InlayHints == 0 or not result then
    return
  end

  for _, hint in pairs(result) do
    local virt_text = {}

    if hint.kind == 1 and options.padding then
      table.insert(virt_text, { " ", options.highlights.padding.name })
    end

    if type(hint.label) == "string" then
      table.insert(virt_text, { hint.label, options.highlights.hint.name })
    else
      local text = ""
      for _, label_part in pairs(hint.label) do
        text = text .. label_part.value
      end
      table.insert(virt_text, { text, options.highlights.hint.name })
    end

    if hint.kind ~= 1 and options.padding then
      table.insert(virt_text, { " ", options.highlights.padding.name })
    end

    pcall(
      vim.api.nvim_buf_set_extmark,
      ctx.bufnr,
      namespaces[ctx.client_id],
      hint.position.line,
      hint.position.character,
      {
        virt_text_pos = "inline",
        virt_text = virt_text,
        hl_mode = "combine",
      }
    )
  end
end

function M.display()
  local params = {
    textDocument = vim.lsp.util.make_text_document_params(0),
    range = {
      start = { line = 0, character = 0 },
      ["end"] = { line = vim.api.nvim_buf_line_count(0), character = 0 },
    },
  }

  vim.lsp.buf_request(0, "textDocument/inlayHint", params, handler)
end

---@param config? InlayHintConfig
function M.config(config)
  options = vim.tbl_deep_extend("force", options, config)

  set_highlights()
  M.display()
end

function M.toggle()
  vim.g.InlayHints = vim.g.InlayHints == 0 and 1 or 0

  M.display()
end

function M.setup(bufnr)
  vim.api.nvim_clear_autocmds {
    group = group,
    buffer = bufnr,
  }
  vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI", "BufEnter" }, {
    group = group,
    buffer = bufnr,
    callback = M.display,
  })

  vim.keymap.set("n", "<Leader>li", M.toggle, { desc = "Toggle Inlay Hints" })

  set_highlights()

  vim.api.nvim_create_autocmd("CursorHold", {
    group = group,
    once = true,
    buffer = bufnr,
    callback = M.display,
  })
end

return M
