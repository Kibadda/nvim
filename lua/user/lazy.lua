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

require("lazy").setup({
  { import = "user.plugins.dev" },
  { import = "user.plugins.themes" },
  { import = "user.plugins" },
}, {
  defaults = {
    lazy = true,
  },
  dev = {
    pattern = { "Kibadda" },
    path = "~/plugins",
    fallback = true,
  },
  install = {
    -- missing = false,
    colorscheme = { "tundra" },
  },
  ui = {
    title = " Lazy ",
    border = "single",
    ---@type table<string, fun(plugin: LazyPlugin)>
    custom_keys = {
      t = function(plugin)
        require("lazy.util").float_term(nil, {
          cwd = plugin.dir,
        })
      end,
      gB = function(plugin)
        vim.system { "xdg-open", plugin.url }
      end,
    },
  },
  diff = {
    cmd = "terminal_git",
  },
  change_detection = {
    notify = false,
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
