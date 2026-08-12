if vim.g.loaded_plugin_git then
  return
end

vim.g.loaded_plugin_git = 1

vim.keymap.set("ca", "GIt", "Git")
vim.keymap.set("ca", "GIT", "Git")

vim.api.nvim_create_user_command("Git", function(data)
  require("me.git").run(data)
end, {
  bang = false,
  bar = false,
  nargs = "*",
  complete = function(_, cmdline, _)
    return require("me.git").complete(cmdline)
  end,
})

vim.keymap.set("n", "<Leader>h", function()
  vim.cmd.Git()
end)

vim.keymap.set("n", "gG", function()
  require("me.git.open").project()
end)

vim.keymap.set({ "n", "x" }, "gF", function()
  require("me.git.open").file()
end)

vim.keymap.set({ "x", "o" }, "ih", function()
  require("me.git.hunk").textobject()
end)

vim.keymap.set({ "n", "x" }, "]h", function()
  require("me.git.hunk").goto_hunk "next"
end)

vim.keymap.set({ "n", "x" }, "[h", function()
  require("me.git.hunk").goto_hunk "prev"
end)

vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI", "BufEnter", "FocusGained", "DirChanged" }, {
  group = vim.api.nvim_create_augroup("GitStatus", { clear = true }),
  callback = function(args)
    local cache = require("me.git.status").cache

    cache[args.buf] = cache[args.buf] or {}

    require("me.git.utils").run({ "rev-parse" }, { "--abbrev-ref", "HEAD" }, function(code1, branch)
      if code1 ~= 0 or not branch or branch[1] == "" then
        cache[args.buf].branch = "no git"
      elseif branch[1] ~= "HEAD" then
        cache[args.buf].branch = branch[1]
      else
        require("me.git.utils").run({ "rev-parse" }, { "--short", "HEAD" }, function(code2, hash)
          if code2 ~= 0 or not hash[1] or hash[1] == "" then
            cache[args.buf].branch = "HEAD"
          else
            cache[args.buf].branch = "HEAD " .. hash[1]
          end
        end)
      end
    end)

    if vim.bo[args.buf].buftype == "" then
      local bufname = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(args.buf), ":.")

      require("me.git.utils").run(
        { "show" },
        { ":" .. bufname },
        vim.schedule_wrap(function(code, result)
          if not vim.api.nvim_buf_is_valid(args.buf) then
            return
          end

          if code ~= 0 then
            cache[args.buf].diff = { added = 0, changed = 0, removed = 0 }
            cache[args.buf].hunks = {}
            require("me.git.hunk").set_diff_extmarks(args.buf, {})
            return
          end

          local current = vim.api.nvim_buf_get_lines(args.buf, 0, -1, false)

          local diff = { added = 0, changed = 0, removed = 0 }
          local marks = {}
          local hunks = {}

          vim.text.diff(table.concat(result, "\n"), table.concat(current, "\n"), {
            ignore_whitespace_change = true,
            on_hunk = function(_, c1, s2, c2)
              if c1 == 1 and c2 > 1 then
                diff.added = diff.added + c2
              elseif c1 > 1 and c2 == 1 then
                diff.removed = diff.removed + c1
              else
                local delta = math.min(c1, c2)
                diff.changed = diff.changed + delta
                diff.added = diff.added + c2 - delta
                diff.removed = diff.removed + c1 - delta
              end

              local hunk_type = c1 == 0 and "add" or (c2 == 0 and "delete" or "change")
              local from = math.max(s2, 1)
              local to = from + math.max(c2, 1) - 1

              table.insert(hunks, { buf_start = s2, buf_count = c2 })

              for lnum = from, to do
                if marks[lnum] == nil or hunk_type == "change" then
                  marks[lnum] = require("me.git.hunk").types[hunk_type]
                end
              end

              return 0
            end,
          })

          cache[args.buf].diff = diff
          cache[args.buf].hunks = hunks
          require("me.git.hunk").set_diff_extmarks(args.buf, marks)
        end)
      )
    end
  end,
})
