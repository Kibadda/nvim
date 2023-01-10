local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    "git",
    "clone",
    "--filter=blob:none",
    "--single-branch",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  }
end
vim.opt.runtimepath:prepend(lazypath)

require("lazy").setup("user.plugins", {
  dev = {
    pattern = { "Kibadda" },
    path = "~/plugins",
  },
  ui = {
    border = "single",
    ---@type table<string, fun(plugin: LazyPlugin)>
    custom_keys = {
      t = function(plugin)
        require("lazy.util").float_term(nil, {
          cwd = plugin.dir,
        })
      end,
      l = function(plugin)
        require("lazy.util").float_term({ "git", "log", "--graph", "--decorate", "--oneline" }, {
          cwd = plugin.dir,
        })
      end,
    },
  },
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        "matchit",
        "matchparen",
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})
