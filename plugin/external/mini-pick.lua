vim.pack.add({ "https://github.com/echasnovski/mini.pick" }, { load = true })

if vim.g.loaded_plugin_mini_pick then
  return
end

vim.g.loaded_plugin_mini_pick = 1

local pick = require "mini.pick"

pick.setup {
  mappings = {
    move_down = "<C-j>",
    move_up = "<C-k>",
  },
}

vim.keymap.set("n", "<Leader>f", "<Cmd>Pick files<CR>")
vim.keymap.set("n", "<Leader>F", "<Cmd>Pick files vcs=false<CR>")
vim.keymap.set("n", "<Leader>b", "<Cmd>Pick buffers<CR>")
vim.keymap.set("n", "<Leader>sg", "<Cmd>Pick grep_live<CR>")
vim.keymap.set("n", "<Leader>sh", "<Cmd>Pick help<CR>")
vim.keymap.set("n", "<Leader>sr", "<Cmd>Pick resume<CR>")

local minipick_start = pick.start
--- @diagnostic disable-next-line:duplicate-set-field
function pick.start(opts)
  opts = opts or {}
  opts.mappings = opts.mappings or {}
  opts.mappings.choose_in_tabpage = ""

  if opts.initial_query then
    local query = opts.initial_query

    vim.api.nvim_create_autocmd("User", {
      pattern = "MiniPickStart",
      once = true,
      callback = function()
        pick.set_picker_query(query)
      end,
    })

    opts.initial_query = nil
  end

  if opts.with_qflist then
    opts.with_qflist = nil
    opts.mappings.qflist = {
      char = "<C-q>",
      func = function()
        local items = {}
        for _, item in ipairs(pick.get_picker_matches().all) do
          if type(item) == "table" then
            if not item.filename then
              item.filename = item.path
            end
            table.insert(items, item)
          elseif type(item) == "string" then
            local split = vim.split(item, "\x00")

            table.insert(items, {
              filename = split[1],
              lnum = split[2],
              col = split[3],
              text = table.concat(split, "\x00", 4),
            })
          end
        end

        vim.fn.setqflist({}, " ", {
          title = opts.source and opts.source.name or "Pick",
          items = items,
        })
        pick.stop()
        vim.cmd.copen()
        vim.cmd.cfirst()
      end,
    }
  end

  minipick_start(opts)
end

function pick.registry.lsp(opts)
  opts = opts or {}

  pick.start {
    source = {
      name = opts.title or "LSP",
      items = vim.tbl_map(function(item)
        item.path = item.filename
        return item
      end, opts.items),
      show = function(bufnr, items, query)
        pick.default_show(bufnr, items, query, { show_icons = true })
      end,
      choose = function(item)
        pick.default_choose(item)
      end,
    },
  }
end

function pick.registry.buffers()
  pick.builtin.buffers({}, {
    mappings = {
      wipeout = {
        char = "<C-d>",
        func = function()
          local bufnr = pick.get_picker_matches().current.bufnr
          if vim.api.nvim_buf_is_valid(bufnr) then
            vim.api.nvim_buf_delete(bufnr, {})
            pick.registry.buffers()
          end
        end,
      },
    },
  })
end

function pick.registry.grep_live()
  pick.builtin.grep_live({}, {
    with_qflist = true,
  })
end

function pick.registry.files(opts)
  opts = opts or {}

  local vcs = opts.vcs ~= false

  local command = { "rg", "--files", "--no-follow", "--color=never", "--hidden" }

  if not vcs then
    table.insert(command, "--no-ignore-vcs")
  end

  pick.builtin.cli({
    command = command,
    postprocess = function(items)
      items = vim.tbl_filter(function(item)
        return item ~= "" and not vim.startswith(item, ".git/")
      end, items)

      table.sort(items)

      return items
    end,
  }, {
    initial_query = opts.query,
    source = {
      name = vcs and "Files" or "All Files",
      show = function(bufnr, items, que)
        pick.default_show(bufnr, items, que, { show_icons = true })
      end,
    },
    mappings = {
      choose_in_tabpage = "",
      toggle = {
        char = "<C-t>",
        func = function()
          pick.registry.files { vcs = not vcs, query = pick.get_picker_query() }
        end,
      },
    },
  })
end
