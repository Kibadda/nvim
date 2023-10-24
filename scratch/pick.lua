MiniPick.registry.testing = function(local_opts)
  local_opts = vim.tbl_extend("force", {
    show_hidden = false,
    show_gitignore = false,
    cwd = vim.fn.fnamemodify(vim.uv.cwd(), ":."),
  }, local_opts or {})

  local function absolute_path(path)
    path = local_opts.cwd .. (path and "/" .. path or "")
    return vim.fs.normalize(vim.fn.fnamemodify(path, ":p") --[[@as string]])
  end

  local function is_directory(item)
    return vim.fn.isdirectory(absolute_path(item)) == 1
  end

  local function set_items()
    vim.print(local_opts)
    local cmd = { "fd", "-d1", "-cnever" }
    if local_opts.show_hidden then
      cmd[#cmd + 1] = "-H"
    end
    if local_opts.show_gitignore then
      cmd[#cmd + 1] = "-I"
    end

    MiniPick.set_picker_items_from_cli(cmd, {
      spawn_opts = {
        cwd = local_opts.cwd,
      },
      set_items_opts = {
        do_match = false,
      },
    })
    MiniPick.set_picker_query { "" }
    MiniPick.set_picker_opts {
      source = {
        name = "Explorer "
          .. local_opts.cwd
          .. " (hidden: "
          .. (local_opts.show_hidden and "true" or "false")
          .. ", git: "
          .. (local_opts.show_gitignore and "true" or "false")
          .. ")",
        cwd = local_opts.cwd,
      },
    }
    vim.defer_fn(MiniPick.refresh, 100)
  end

  local function update_opts(opts)
    if opts.show_hidden ~= nil then
      local_opts.show_hidden = opts.show_hidden
    end
    if opts.show_gitignore ~= nil then
      local_opts.show_gitignore = opts.show_gitignore
    end
    if opts.cwd ~= nil then
      if local_opts.cwd == vim.uv.cwd() and opts.cwd == "../" then
        return
      end
      local_opts.cwd = vim.fs.normalize(vim.fn.fnamemodify(local_opts.cwd .. "/" .. opts.cwd, ":p") --[[@as string]])
    end

    set_items()
  end

  MiniPick.start {
    source = {
      items = vim.schedule_wrap(set_items),
      show = function(buf_id, items, query)
        MiniPick.default_show(buf_id, items, query, { show_icons = true })
      end,
      choose = function(item)
        if is_directory(item) then
          update_opts { cwd = item }
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
          update_opts { cwd = "../" }
        end,
      },
      toggle_hidden = {
        char = "<M-h>",
        func = function()
          update_opts { show_hidden = not local_opts.show_hidden }
        end,
      },
      toggle_git = {
        char = "<M-g>",
        func = function()
          update_opts { show_gitignore = not local_opts.show_gitignore }
        end,
      },
      create = {
        char = "<C-CR>",
        func = function()
          local query_table = MiniPick.get_picker_query()
          if query_table then
            local query = table.concat(query_table)

            if query:sub(-1) == "/" then
              local res = vim.system({ "mkdir", absolute_path(query) }):wait()
              if res.code == 0 then
                update_opts { cwd = query }
              end
            else
              local res = vim.system({ "touch", absolute_path(query) }):wait()
              if res.code == 0 then
                MiniPick.default_choose(query)
                return true
              end
            end
          end
        end,
      },
    },
  }
end

MiniPick.registry.testing {
  show_hidden = false,
  show_gitignore = false,
}
