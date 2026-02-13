local M = {
  cmd = { "diff" },
  can_refresh = true,
  show_output_in_buffer = true,
}

M.lsp = {
  [vim.lsp.protocol.Methods.textDocument_codeAction] = function(params)
    --- @cast params lsp.CodeActionParams

    if params.range.start.line ~= params.range["end"].line then
      return {}
    end

    local bufnr = vim.uri_to_bufnr(params.textDocument.uri)

    local reverse = vim.b[bufnr].fargs[1] == "--cached"

    local hunk_start, hunk_end = nil, nil
    local block_start, block_end = nil, nil
    local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
    local filename = nil

    for i = params.range.start.line + 1, 1, -1 do
      if not hunk_start and vim.startswith(lines[i], "@@") then
        hunk_start = i
      end
      if not block_start and vim.startswith(lines[i], "diff") then
        block_start = i
      end
      if not filename and vim.startswith(lines[i], "+++") then
        filename = string.sub(lines[i], 7)
      end
    end

    for i = params.range.start.line + 1, #lines do
      if
        not hunk_end
        and (not lines[i + 1] or vim.startswith(lines[i + 1], "diff") or vim.startswith(lines[i + 1], "@@"))
      then
        hunk_end = i
      end
      if not block_end and (not lines[i + 1] or vim.startswith(lines[i + 1], "diff")) then
        block_end = i
      end
    end

    local codeactions = {}

    if hunk_start and hunk_end then
      table.insert(codeactions, {
        title = reverse and "unstage hunk" or "stage hunk",
        command = {
          title = reverse and "unstage hunk" or "stage hunk",
          command = "apply_patch",
          arguments = {
            bufnr = bufnr,
            reverse = reverse,
            patch = vim.list_extend(
              vim.api.nvim_buf_get_lines(bufnr, block_start - 1, block_start + 3, false),
              vim.api.nvim_buf_get_lines(bufnr, hunk_start - 1, hunk_end, false)
            ),
          },
        },
      })
    end

    if block_start and block_end then
      table.insert(codeactions, {
        title = reverse and "unstage block" or "stage block",
        command = {
          title = reverse and "unstage block" or "stage block",
          command = "apply_patch",
          arguments = {
            bufnr = bufnr,
            reverse = reverse,
            patch = vim.api.nvim_buf_get_lines(bufnr, block_start - 1, block_end, false),
          },
        },
      })
    end

    if not reverse and filename then
      table.insert(codeactions, {
        title = "stage hunk --edit",
        command = {
          title = "stage hunk --edit",
          command = "add",
          arguments = {
            bufnr = bufnr,
            edit = true,
            files = { filename },
          },
        },
      })
    end

    table.insert(codeactions, {
      title = reverse and "unstage diff" or "stage diff",
      command = {
        title = reverse and "unstage diff" or "stage diff",
        command = "apply_patch",
        arguments = {
          bufnr = bufnr,
          reverse = reverse,
          patch = lines,
        },
      },
    })

    return codeactions
  end,
}

function M:pre_run(fargs)
  if #fargs ~= 1 or fargs[1]:match "[a-z0-9%.]*" == nil then
    if fargs[1] == "--cached" then
      table.insert(fargs, 2, "--")
    else
      table.insert(fargs, 1, "--")
    end
  end
end

function M.completions(fargs)
  if #fargs > 1 then
    if fargs[1] == "--cached" then
      return require("me.git.cache").staged
    else
      return require("me.git.cache").unstaged
    end
  else
    return vim.list_extend({ "--cached" }, require("me.git.cache").unstaged)
  end
end

function M:on_buf_load()
  return {
    keymaps = {
      {
        lhs = "[[",
        mode = { "n", "x" },
        rhs = function()
          for _ = 1, vim.v.count1 do
            vim.fn.search("^@@ ", "bsW")
          end
        end,
      },
      {
        lhs = "]]",
        mode = { "n", "x" },
        rhs = function()
          for _ = 1, vim.v.count1 do
            vim.fn.search("^@@ ", "sW")
          end
        end,
      },
    },
  }
end

return M
