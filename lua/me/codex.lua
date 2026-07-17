local M = {}

local config = {
  command = "codex",
  direct_prompt_limit = 30000,
  split_ratio = 0.4,
  split_height = 40,
}

local function current_root()
  return vim.uv.cwd() or vim.fn.getcwd()
end

local function current_path(buf)
  local name = vim.api.nvim_buf_get_name(buf)
  if name == "" then
    return "[No Name]"
  end

  return vim.fn.fnamemodify(name, ":~:.")
end

local function fence_for(text)
  if text:find("```", 1, true) then
    return "````"
  end

  return "```"
end

local function context_prompt(context, request)
  local fence = fence_for(context.text)
  local lines = {
    ("Use the following %s as context."):format(context.kind),
    "",
    ("File: %s"):format(context.path),
    ("Filetype: %s"):format(context.filetype ~= "" and context.filetype or "text"),
    "",
    ("%s%s"):format(fence, context.filetype ~= "" and context.filetype or ""),
    context.text,
    fence,
  }

  if request and request ~= "" then
    vim.list_extend(lines, {
      "",
      "Request:",
      request,
    })
  end

  return table.concat(lines, "\n")
end

local function prepare_prompt(prompt)
  if prompt == "" or #prompt <= config.direct_prompt_limit then
    return prompt
  end

  local file = vim.fn.tempname() .. ".md"
  vim.fn.writefile(vim.split(prompt, "\n", { plain = true }), file, "b")

  return ("Read the Neovim context and request from this file before responding: %s"):format(file), vim.fs.dirname(file)
end

local function open_terminal(prompt, extra_dir)
  if vim.fn.executable(config.command) == 0 then
    vim.notify(("Cannot find %q on $PATH"):format(config.command), vim.log.levels.ERROR)
    return
  end

  local root = current_root()
  local cmd = { config.command, "--cd", root }
  if extra_dir then
    vim.list_extend(cmd, { "--add-dir", extra_dir })
  end
  if prompt and prompt ~= "" then
    table.insert(cmd, prompt)
  end

  local buf = vim.api.nvim_create_buf(true, false)
  pcall(vim.api.nvim_buf_set_name, buf, ("codex://%d"):format(vim.uv.hrtime()))

  local height = math.min(math.floor(vim.o.lines * config.split_ratio + 0.5), config.split_height)
  vim.api.nvim_open_win(buf, true, {
    win = -1,
    split = "below",
    height = height,
  })

  vim.bo[buf].buflisted = false
  vim.fn.jobstart(cmd, {
    cwd = root,
    term = true,
    on_exit = function(_, code)
      if code ~= 0 then
        vim.schedule(function()
          vim.notify(("Codex exited with code %d"):format(code), vim.log.levels.WARN)
        end)
      end
    end,
  })
end

local function input_prompt(callback)
  vim.ui.input({ prompt = "Codex prompt: " }, function(input)
    if input == nil then
      return
    end

    callback(input)
  end)
end

local function run(prompt)
  local prepared, extra_dir = prepare_prompt(prompt or "")
  open_terminal(prepared, extra_dir)
end

function M.open(opts)
  opts = opts or {}
  run(opts.prompt or "")
end

function M.buffer(opts)
  opts = opts or {}
  local buf = vim.api.nvim_get_current_buf()
  local context = {
    kind = "buffer",
    path = current_path(buf),
    filetype = vim.bo[buf].filetype,
    text = table.concat(vim.api.nvim_buf_get_lines(buf, 0, -1, false), "\n"),
  }

  local function start(request)
    run(context_prompt(context, request))
  end

  if opts.ask then
    input_prompt(start)
  else
    start(opts.prompt or "")
  end
end

function M.selection(opts)
  opts = opts or {}
  local buf = vim.api.nvim_get_current_buf()
  local line1 = opts.line1 or vim.fn.line "'<"
  local line2 = opts.line2 or vim.fn.line "'>"

  if line1 > line2 then
    line1, line2 = line2, line1
  end

  local context = {
    kind = "selection",
    path = current_path(buf),
    filetype = vim.bo[buf].filetype,
    text = table.concat(vim.api.nvim_buf_get_lines(buf, line1 - 1, line2, false), "\n"),
  }

  local function start(request)
    run(context_prompt(context, request))
  end

  if opts.ask then
    input_prompt(start)
  else
    start(opts.prompt or "")
  end
end

return M
