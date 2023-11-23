return {
  "echasnovski/mini.starter",
  enabled = not vim.g.started_as_db_client and vim.fn.argc() == 0,
  event = "VimEnter",
  opts = function()
    local sections = require("projectodo").get_sections "mini-starter"

    table.insert(sections, 1, function()
      return {
        {
          name = "Quit",
          action = "q",
          section = "",
        },
        {
          name = "Edit New Buffer",
          action = "enew",
          section = "",
        },
      }
    end)

    local weekday = os.date "%w"
    local day = table.concat(require("user.data.weekdays")[tonumber(weekday == "0" and 7 or weekday)], "\n")

    return {
      header = function()
        return day:gsub("AAAAAAAAAA", os.date "%d.%m.%Y")
      end,
      items = sections,
      footer = function()
        local stats = require("lazy").stats()
        return ("Loaded %d/%d plugins in %dms"):format(stats.loaded, stats.count, stats.startuptime)
      end,
      content_hooks = {
        require("mini.starter").gen_hook.adding_bullet(),
        function(content, buf_id)
          local win_id = vim.fn.bufwinid(buf_id)
          if not win_id or win_id < 0 then
            return
          end

          local splitted = {
            header = {
              lines = {},
              width = 0,
              pad = 0,
            },
            items = {
              lines = {},
              width = 0,
              pad = 0,
            },
            footer = {
              lines = {},
              width = 0,
              pad = 0,
            },
          }

          for _, c in ipairs(content) do
            if c[1].type == "header" then
              table.insert(splitted.header.lines, c)
            elseif c[1].type == "footer" then
              table.insert(splitted.footer.lines, c)
            else
              table.insert(splitted.items.lines, c)
            end
          end

          for _, val in pairs(splitted) do
            for _, l in ipairs(MiniStarter.content_to_lines(val.lines)) do
              val.width = math.max(val.width, vim.fn.strdisplaywidth(l))
            end
            val.pad = math.max(math.floor(0.5 * (vim.api.nvim_win_get_width(win_id) - val.width)), 0)
          end

          local bottom_space = vim.api.nvim_win_get_height(win_id) - #content
          local top_pad = math.max(math.floor(0.5 * bottom_space), 0)

          content = MiniStarter.gen_hook.padding(splitted.header.pad, top_pad)(splitted.header.lines)
          for _, c in ipairs(MiniStarter.gen_hook.padding(splitted.items.pad, 0)(splitted.items.lines)) do
            table.insert(content, c)
          end
          for _, c in ipairs(MiniStarter.gen_hook.padding(splitted.footer.pad, 0)(splitted.footer.lines)) do
            table.insert(content, c)
          end

          return content
        end,
      },
    }
  end,
  init = function()
    vim.api.nvim_create_autocmd("User", {
      group = vim.api.nvim_create_augroup("MiniStarterKeymaps", { clear = true }),
      pattern = "MiniStarterOpened",
      callback = function(args)
        vim.opt.cmdheight = 0
        vim.opt.showtabline = 0
        vim.opt.laststatus = 0
        vim.opt_local.statuscolumn = ""
        vim.opt_local.winbar = ""
        vim.keymap.set("n", "<C-j>", function()
          MiniStarter.update_current_item "next"
        end, { desc = "Move down", buffer = args.buf })
        vim.keymap.set("n", "<C-k>", function()
          MiniStarter.update_current_item "prev"
        end, { desc = "Move up", buffer = args.buf })

        vim.api.nvim_create_autocmd("BufUnload", {
          group = vim.api.nvim_create_augroup("ResetOptionsOnMiniStarterLeave", { clear = true }),
          buffer = args.buf,
          callback = function()
            vim.opt.cmdheight = 1
            vim.opt.showtabline = 2
            vim.opt.laststatus = 3
          end,
        })
      end,
    })

    vim.api.nvim_create_autocmd("User", {
      group = vim.api.nvim_create_augroup("UpdateLazyStatsInMiniStarter", { clear = true }),
      pattern = "LazyVimStarted",
      callback = function()
        if vim.bo.filetype == "starter" then
          MiniStarter.refresh()
        end
      end,
    })
  end,
  config = function(_, opts)
    require("mini.starter").setup(opts)

    local ok, colors = pcall(require, "nvim-tundra.palette.arctic")
    if ok and colors then
      vim.cmd.highlight("MiniStarterHeader guifg=" .. colors.red._600)
      vim.cmd.highlight("MiniStarterSection guifg=" .. colors.green._600)
    end
  end,
}
