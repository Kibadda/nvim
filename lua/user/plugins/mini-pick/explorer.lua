local function default_sort(items)
  local res = vim.tbl_map(function(x)
    return {
      fs_type = x.fs_type,
      path = x.path,
      text = x.text,
      is_dir = x.fs_type == "directory",
      lower_name = x.text:lower(),
    }
  end, items)

  local compare = function(a, b)
    if a.is_dir and not b.is_dir then
      return true
    end
    if not a.is_dir and b.is_dir then
      return false
    end

    return a.lower_name < b.lower_name
  end

  table.sort(res, compare)

  return vim.tbl_map(function(x)
    return { fs_type = x.fs_type, path = x.path, text = x.text }
  end, res)
end

local function make_items(path, filter, sort)
  if vim.fn.isdirectory(path) == 0 then
    return {}
  end

  filter = filter or function()
    return true
  end

  sort = sort or default_sort

  local res = { { fs_type = "directory", path = vim.fn.fnamemodify(path, ":h"), text = ".." } }

  for _, basename in ipairs(vim.fn.readdir(path)) do
    local subpath = string.format("%s/%s", path, basename)
    local fs_type = vim.fn.isdirectory(subpath) == 1 and "directory" or "file"
    table.insert(res, { fs_type = fs_type, path = subpath, text = basename .. (fs_type == "directory" and "/" or "") })
  end

  return sort(vim.tbl_filter(filter, res))
end

---@param callback fun(current: table, picker_opts: table, done: function)
local function get_current(callback)
  return function()
    local picker_opts = MiniPick.get_picker_opts()
    if not picker_opts then
      return
    end

    local current = MiniPick.get_picker_matches().current

    if not current then
      return
    end

    callback(current, picker_opts, function(local_opts)
      MiniPick.set_picker_items(
        make_items(picker_opts.source.cwd, local_opts.filter, local_opts.sort),
        { do_match = true }
      )
    end)
  end
end

return function(local_opts, start_opts)
  start_opts = start_opts or {}
  start_opts.mappings = {
    files = {
      char = "<C-n>",
      func = function()
        MiniPick.registry.files()
        return true
      end,
    },
    create = {
      char = "<C-CR>",
      func = function()
        local query_table = MiniPick.get_picker_query()
        local picker_opts = MiniPick.get_picker_opts()

        if query_table and picker_opts then
          local query = table.concat(query_table)
          local path = picker_opts.source.cwd .. "/" .. query

          if vim.fn.isdirectory(path) == 1 or (query:sub(-1) ~= "/" and vim.fn.filereadable(path) == 1) then
            picker_opts.source.choose(MiniPick.get_picker_matches().current)
          else
            if query:sub(-1) == "/" then
              if vim.system({ "mkdir", path }):wait().code == 0 then
                picker_opts.source.choose { path = vim.fs.normalize(path) }
              end
            else
              vim.defer_fn(function()
                vim.cmd.edit(path)
              end, 1)
              return true
            end
          end
        end
      end,
    },
    copy = {
      char = "<M-c>",
      func = get_current(function(current, picker_opts, done)
        vim.ui.input({ prompt = "File name: ", default = current.text }, function(input)
          if input and #input > 0 then
            if vim.system({ "cp", current.text, input }, { cwd = picker_opts.source.cwd }):wait().code == 0 then
              done(local_opts)
            end
          end
        end)
      end),
    },
    delete = {
      char = "<M-d>",
      func = get_current(function(current, _, done)
        if not vim.fn.isdirectory(current.path) or vim.fn.confirm("Delete " .. current.path, "&Yes\n&No", 2) == 1 then
          vim.defer_fn(function()
            if vim.system({ "rm", "-rf", current.path }):wait().code == 0 then
              done(local_opts)
            end
          end, 1)
        end
      end),
    },
    rename = {
      char = "<M-r>",
      func = get_current(function(current, picker_opts, done)
        vim.ui.input({ prompt = "Rename file: ", default = current.text }, function(input)
          if input and #input > 0 then
            if vim.system({ "mv", current.text, input }, { cwd = picker_opts.source.cwd }):wait().code == 0 then
              done(local_opts)
            end
          end
        end)
      end),
    },
  }

  return MiniExtra.pickers.explorer(local_opts, start_opts)
end
