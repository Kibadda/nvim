MiniPick.registry.testing = function(local_opts)
  local root = vim.uv.cwd()

  local_opts = vim.tbl_extend("force", {
    show_hidden = false,
    show_gitignore = false,
    cwd = vim.fn.fnamemodify(root, ":."),
  }, local_opts or {})

  local function absolute_path(path)
    path = local_opts.cwd .. (path and "/" .. path or "")
    return vim.fs.normalize(vim.fn.fnamemodify(path, ":p") --[[@as string]])
  end

  local function set_items()
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

  local function toggle(name)
    local_opts[name] = not local_opts[name]
    set_items()
  end

  local function cd(path)
    if path ~= "../" or local_opts.cwd ~= root then
      local_opts.cwd = vim.fs.normalize(vim.fn.fnamemodify(local_opts.cwd .. "/" .. path, ":p") --[[@as string]])
      set_items()
    end
  end

  MiniPick.start {
    source = {
      items = vim.schedule_wrap(set_items),
      show = function(buf_id, items, query)
        MiniPick.default_show(buf_id, items, query, { show_icons = true })
      end,
      choose = function(item)
        if vim.fn.isdirectory(absolute_path(item)) == 1 then
          cd(item)
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
          cd "../"
        end,
      },
      toggle_hidden = {
        char = "<M-h>",
        func = function()
          toggle "show_hidden"
        end,
      },
      toggle_git = {
        char = "<M-g>",
        func = function()
          toggle "show_gitignore"
        end,
      },
      create = {
        char = "<C-CR>",
        func = function()
          local query_table = MiniPick.get_picker_query()

          if query_table then
            local query = table.concat(query_table)
            local path = absolute_path(query)

            if vim.fn.isdirectory(path) == 1 or (query:sub(-1) ~= "/" and vim.fn.filereadable(path) == 1) then
              MiniPick.get_picker_opts().source.choose(MiniPick.get_picker_matches().current)
            else
              if query:sub(-1) == "/" then
                if vim.system({ "mkdir", path }):wait().code == 0 then
                  cd(query)
                end
              else
                if vim.system({ "touch", path }):wait().code == 0 then
                  MiniPick.default_choose(query)
                  return true
                end
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
  cwd = vim.fn.expand "%:p:h",
}
