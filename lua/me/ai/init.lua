--- @class me.ai.tool
--- @field cmd string[]

local M = {
  --- @type table<string, me.ai.tool>
  tools = {
    claude = {
      cmd = { "claude" },
    },
    opencode = {
      cmd = { "opencode" },
    },
  },

  prompts = {
    ["{buffer}"] = function()
      local path = vim.fn.fnamemodify(vim.fn.expand "%", ":.")

      return "@" .. path .. " "
    end,
    ["{dir}"] = function()
      local path = vim.fn.fnamemodify(vim.fn.expand "%", ":h")

      return "@" .. path .. " "
    end,
    ["{line}"] = function(args)
      local path = vim.fn.fnamemodify(vim.fn.expand "%", ":.")

      return "@" .. path .. ":L" .. args.line1 .. " "
    end,
    ["{this}"] = function(args)
      local path = vim.fn.fnamemodify(vim.fn.expand "%", ":.")

      if args.range == 0 then
        local cursor = vim.api.nvim_win_get_cursor(0)

        return "@" .. path .. ":L" .. args.line1 .. ":C" .. (cursor[2] + 1) .. " "
      elseif args.line1 == args.line2 then
        return "@" .. path .. ":L" .. args.line1 .. " "
      else
        return "@" .. path .. ":L" .. args.line1 .. "-L" .. args.line2 .. " "
      end
    end,
  },
}

local last_ai

function M.run(cmdargs)
  local split = vim.split(cmdargs.args, " ")

  local tool

  if M.tools[split[1]] then
    tool = M.tools[split[1]]

    table.remove(split, 1)
  elseif last_ai then
    tool = last_ai
  else
    vim.ui.select(vim.tbl_keys(M.tools), {
      prompt = "Select tool: ",
    }, function(choice)
      if choice then
        tool = M.tools[choice]
      end
    end)
  end

  if not tool then
    vim.print "AI: tool must be selected"

    return
  end

  last_ai = tool

  local prompt = table.concat(split, " ")

  for placeholder, replace in pairs(M.prompts) do
    prompt = prompt:gsub(placeholder, function()
      return replace(cmdargs)
    end)
  end

  local terminal = require("me.ai.terminal").get(tool)

  terminal:send(prompt)
end

function M.complete(cmdline)
  local cmd = cmdline:match "^AI%s+(%S*)$"

  if cmd then
    return vim.tbl_filter(function(tool)
      return vim.startswith(tool, cmd)
    end, vim.tbl_keys(M.tools))
  end

  cmd = cmdline:match "(%S+)$"

  if cmd and vim.startswith(cmd, "{") then
    return vim.tbl_filter(function(prompt)
      return vim.startswith(prompt, cmd)
    end, vim.tbl_keys(M.prompts))
  end

  return {}
end

return M
