local function fzy(a)
  local saved_spk = vim.o.splitkeep
  local src_winid = vim.fn.win_getid()
  local fzy_lines = (vim.v.count > 2 and vim.v.count) or 10
  local tempfile = vim.fn.tempname()
  local term_cmd = a.input .. " | fzy -l" .. fzy_lines .. " > " .. tempfile

  local on_exit = function()
    vim.cmd.bwipeout()
    vim.o.splitkeep = saved_spk
    vim.fn.win_gotoid(src_winid)
    if vim.fn.filereadable(tempfile) then
      local lines = vim.fn.readfile(tempfile)
      if #lines > 0 then
        (a.action or vim.cmd.edit)(lines[1])
      end
    end
    vim.fn.delete(tempfile)
  end

  vim.o.splitkeep = "screen"
  vim.cmd("botright" .. (fzy_lines + 1) .. "new")
  local id = vim.fn.termopen(term_cmd, { on_exit = on_exit, env = a.env })
  vim.keymap.set("n", "<Esc>", function()
    vim.fn.jobstop(id)
  end, { buffer = true })
  vim.cmd "keepalt file fzy"
  vim.cmd.startinsert()
end

local function fd()
  local inp = vim.fn.input "fd -H "
  if #inp < 1 then
    return
  end
  fzy { input = "fdfind -H " .. inp }
end

local function rg()
  local inp = vim.fn.input "rg --vimgrep "
  if #inp < 1 then
    return
  end
  fzy {
    input = "rg --vimgrep " .. inp,
    action = function(line)
      local file, lnum, col = unpack(vim.split(line, ":"))
      vim.cmd.edit(file)
      vim.fn.cursor { lnum, col }
      vim.cmd "normal! zz"
    end,
  }
end

local function buffers()
  fzy {
    env = { NVIM_BUFFERS = vim.fn.execute "ls" },
    input = 'echo "$NVIM_BUFFERS"',
    action = function(line)
      vim.cmd("b" .. string.match(line, "%d+"))
    end,
  }
end

local function history()
  local hist = vim.split(vim.fn.execute "history cmd", "\n")
  for i = 1, #hist do
    hist[i] = hist[i]:gsub(">?%s*%S+%s*", ":", 1)
  end
  fzy {
    env = { NVIM_HISTORY = table.concat(vim.fn.reverse(hist), "\n") },
    input = 'echo "$NVIM_HISTORY"',
    action = function(line)
      vim.cmd(line:gsub(":", "", 1))
    end,
  }
end

local function oldfiles()
  fzy {
    env = { NVIM_OLDFILES = table.concat(vim.v.oldfiles, "\n") },
    input = 'echo "$NVIM_OLDFILES"',
  }
end

local function jumplist()
  local prepare_jumplist = function()
    local jumps = vim.split(vim.fn.execute "jumps", "\n", { trimemtpy = true })
    local current_pos = nil
    for n, line in ipairs(jumps) do
      if line:match "^%s*>" then
        current_pos = n
      end
    end
    for n, line in ipairs(jumps) do
      if n > 1 then
        local prefix = " "
        if n < current_pos then
          prefix = "-"
        end
        if n > current_pos then
          prefix = "+"
        end
        jumps[n] = line:gsub("%s", prefix, 1)
      end
    end
    local res = {}
    for i = #jumps, 1, -1 do
      if not jumps[i]:match "^%s*>" and jumps[i]:match "%d" then
        table.insert(res, jumps[i])
      end
    end
    return table.concat(res, "\n")
  end

  fzy {
    env = { NVIM_JUMPS = prepare_jumplist() },
    input = 'echo "$NVIM_JUMPS"',
    action = function(line)
      local n = line:match "%d+"
      local key = vim.api.nvim_replace_termcodes(line:match "^%s*%+" and "<C-i>" or "<C-o>", true, true, true)
      vim.fn.execute("normal! " .. n .. key)
    end,
  }
end
