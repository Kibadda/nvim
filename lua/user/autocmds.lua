local autocmd = vim.api.nvim_create_autocmd
local function augroup(name)
  return vim.api.nvim_create_augroup(name, { clear = true })
end

autocmd("TextYankPost", {
  group = augroup "HighlightYank",
  pattern = "*",
  callback = function()
    vim.highlight.on_yank {
      higroup = "Search",
      timeout = 200,
    }
  end,
})

autocmd("BufEnter", {
  group = augroup "PluginFileKeymap",
  pattern = "*/lua/user/plugins/{*.lua,*/init.lua}",
  callback = function(args)
    require("user.utils").keymaps {
      [{ mode = "n", buffer = args.buf }] = {
        g = {
          P = { "<Cmd>PluginOpen<CR>", "Open Plugin" },
        },
      },
    }
  end,
})

autocmd("BufReadPost", {
  group = augroup "GotoLastPlace",
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

autocmd("VimResized", {
  group = augroup "EqualizeSplitsOnResize",
  callback = function()
    vim.cmd.wincmd "="
  end,
})

autocmd("FileType", {
  group = augroup "UseSpellInGitCommits",
  pattern = { "gitcommit" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
  end,
})

autocmd("BufEnter", {
  group = augroup "DefaultBufferOptions",
  callback = function(args)
    vim.opt_local.formatoptions:remove "t"
    vim.opt_local.formatoptions:remove "o"
    vim.opt_local.formatoptions:append "n"

    if vim.bo[args.buf].buftype == "nofile" then
      vim.opt_local.statuscolumn = nil
    end
  end,
})

autocmd("BufRead", {
  group = augroup "AutocloseBuffer",
  pattern = "*",
  callback = function(args)
    vim.api.nvim_create_autocmd({ "InsertEnter", "BufModifiedSet" }, {
      buffer = args.buf,
      once = true,
      callback = function()
        vim.fn.setbufvar(args.buf, "bufpersist", 1)
      end,
    })
  end,
})

local group = augroup "ChangeKittyTabName"
autocmd("SessionLoadPost", {
  group = group,
  callback = function()
    os.execute(
      ("kitty @ --to %s set-tab-title %s"):format(
        vim.env.KITTY_LISTEN_ON,
        "nvim " .. table.remove(vim.split(vim.v.this_session, "/"))
      )
    )
  end,
})
autocmd("VimLeave", {
  group = group,
  callback = function()
    os.execute(("kitty @ --to %s set-tab-title"):format(vim.env.KITTY_LISTEN_ON))
  end,
})
