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
  local url = require("me.git.utils").get_url()

  if url then
    vim.ui.open(url)
  end
end)

vim.keymap.set("n", "gF", function()
  local url = require("me.git.utils").get_url()

  if not url then
    return
  end

  local branch = require("me.git.utils").run({ "rev-parse" }, { "--abbrev-ref", "HEAD" })[1]

  if not branch or branch == "" then
    return
  end

  local bufname = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":.")

  vim.ui.open(url .. "/blob/" .. branch .. "/" .. bufname)
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
        vim.schedule_wrap(function(_, result)
          if not vim.api.nvim_buf_is_valid(args.buf) then
            return
          end

          local current = vim.api.nvim_buf_get_lines(args.buf, 0, -1, false)

          local diff = { added = 0, changed = 0, removed = 0 }

          vim.text.diff(table.concat(result, "\n"), table.concat(current, "\n"), {
            ignore_whitespace_change = true,
            on_hunk = function(_, c1, _, c2)
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

              return 0
            end,
          })

          cache[args.buf].diff = diff
        end)
      )
    end
  end,
})
