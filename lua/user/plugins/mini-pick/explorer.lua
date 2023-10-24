-- TODO: add keybinds for creating/moving/renaming/deleting (should also change existing buffers)
-- TODO: remove defer_fn call
return function(local_opts)
  local_opts = vim.tbl_extend("force", {
    show_hidden = false,
    show_gitignore = false,
    cwd = vim.fn.fnamemodify(vim.uv.cwd(), ":."),
  }, local_opts or {})

  local show_hidden, show_gitignore, cwd = local_opts.show_hidden, local_opts.show_gitignore, local_opts.cwd

  local function set_items(path)
    if path then
      cwd = path
    end

    local cmd = { "fd", "-d1", "-cnever" }
    if show_hidden then
      cmd[#cmd + 1] = "-H"
    end
    if show_gitignore then
      cmd[#cmd + 1] = "-I"
    end

    MiniPick.set_picker_items_from_cli(cmd, {
      spawn_opts = {
        cwd = cwd,
      },
      set_items_opts = {
        do_match = false,
      },
    })
    MiniPick.set_picker_query { "" }
    MiniPick.set_picker_opts {
      source = {
        name = "Explorer "
          .. cwd
          .. " (hidden: "
          .. (show_hidden and "true" or "false")
          .. ", git: "
          .. (show_gitignore and "true" or "false")
          .. ")",
        cwd = cwd,
      },
    }
    vim.defer_fn(MiniPick.refresh, 100)
  end

  MiniPick.start {
    source = {
      items = vim.schedule_wrap(set_items),
      show = function(buf_id, items, query)
        MiniPick.default_show(buf_id, items, query, { show_icons = true })
      end,
      choose = function(item)
        vim.print "choosing"
        local path = MiniPick.get_picker_opts().source.cwd .. "/" .. item
        if vim.fn.isdirectory(path) == 1 then
          set_items(path)
          return true
        else
          MiniPick.default_choose(item)
        end
      end,
    },
    mappings = {
      up_dir = {
        char = "<C-BS>",
        func = function()
          if vim.fn.fnamemodify(MiniPick.get_picker_opts().source.cwd, ":p") ~= vim.uv.cwd() .. "/" then
            set_items(vim.fn.fnamemodify(MiniPick.get_picker_opts().source.cwd .. "/../", ":p"))
          end
        end,
      },
      toggle_hidden = {
        char = "<M-h>",
        func = function()
          show_hidden = not show_hidden
          set_items()
        end,
      },
      toggle_git = {
        char = "<M-g>",
        func = function()
          show_gitignore = not show_gitignore
          set_items()
        end,
      },
    },
  }
end
