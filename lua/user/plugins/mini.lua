local M = {
  "echasnovski/mini.starter",
  dependencies = {
    {
      "Kibadda/projectodo.nvim",
      dependencies = {
        "nvim-treesitter/nvim-treesitter",
      },
      dev = true,
    },
  },
  event = "VimEnter",
}

local stats

function M.init()
  vim.api.nvim_create_autocmd("User", {
    group = vim.api.nvim_create_augroup("MiniStarterKeymaps", { clear = true }),
    pattern = "MiniStarterOpened",
    callback = function(args)
      vim.opt_local.statuscolumn = nil
      vim.opt_local.winbar = nil
      require("user.utils.register").keymaps {
        [{ mode = "n", buffer = args.buf }] = {
          ["<C-j>"] = {
            function()
              require("mini.starter").update_current_item "next"
            end,
            "Move down",
          },
          ["<C-k>"] = {
            function()
              require("mini.starter").update_current_item "prev"
            end,
            "Move down",
          },
        },
      }
    end,
  })

  vim.api.nvim_create_autocmd("User", {
    group = vim.api.nvim_create_augroup("UpdateLoadedPlugins", { clear = true }),
    pattern = "LazyVimStarted",
    callback = function()
      stats = require("lazy").stats()
    end,
  })
end

function M.config()
  local sections = require("projectodo").get_sections {
    plugin = "mini-starter",
    main_section = {
      name = "Dotfiles",
      sessions = { "dotfiles", "notes", "advent-of-code" },
    },
  }

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

  local day = table.concat(require("user.utils.weekdays")[tonumber(os.date "%w")], "\n")

  require("mini.starter").setup {
    header = function()
      return ("%s\n%s"):format(day, os.date "%d.%m.%Y %H:%M:%S")
    end,
    items = sections,
    footer = function()
      if stats then
        return ("Loaded %d/%d plugins in %dms"):format(stats.loaded, stats.count, stats.startuptime)
      else
        return ""
      end
    end,
  }

  local timer = vim.loop.new_timer()
  timer:start(
    0,
    1000,
    vim.schedule_wrap(function()
      if vim.api.nvim_buf_get_option(0, "filetype") ~= "starter" then
        timer:stop()
      else
        MiniStarter.refresh()
      end
    end)
  )

  local colors = require "nvim-tundra.palette.arctic"
  vim.cmd.highlight("MiniStarterHeader guifg=" .. colors.red._600)
  vim.cmd.highlight("MiniStarterSection guifg=" .. colors.green._600)
end

return M
