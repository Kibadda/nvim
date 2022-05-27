local Job = require "plenary.job"

local M = {}

local get_job = function (str, cwd)
  local job = Job:new {
    command = "rg",
    args = { "--vimgrep", str },

    on_stdout = vim.schedule_wrap(function (_, line)
      local split_line = vim.split(line, ":")

      local filename = split_line[1]
      local lnum = split_line[2]
      local col = split_line[3]

      vim.fn.setqflist({
        {
          filename = filename,
          lnum = lnum,
          col = col,
          text = split_line[4],
        },
      }, "a")
    end),

    on_exit = vim.schedule_wrap(function ()
      vim.cmd [[copen]]
    end),
  }

  return job
end

function M.grep_for_string (str, cwd)
  vim.fn.setqflist({}, "r")
  return get_job(str, cwd):join()
end

function M.replace_string (search, replace, opts)
  opts = opts or {}

  local job = get_job(search, opts.cwd)
  job:add_on_exit_callback(vim.schedule_wrap(function ()
    vim.cmd(string.format("cdo s/%s/%s/g", search, replace))
    vim.cmd [[cdo :update]]
  end))

  return job:sync()
end

KIBADDA_GREP = M

-- vim.keymap.set("n", "<LEADER>ff", function ()
--   KIBADDA_GREP.grep_for_string(vim.fn.input("Grep For > "))
-- end)
-- vim.keymap.set("n", "<LEADER>fr", function ()
--   KIBADDA_GREP.replace_string(vim.fn.input("Grep For > "), vim.fn.input("Replace with > "))
-- end)

return M
