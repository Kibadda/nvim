local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  vim.system {
    "git",
    "clone",
    "--filter=blob:none",
    "--single-branch",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  }
end
vim.opt.runtimepath:prepend(lazypath)

vim.keymap.set("n", "<Leader>L", "<Cmd>Lazy<CR>", { desc = "Lazy" })

require("lazy").setup({
  { import = "user.plugins" },
}, {
  defaults = {
    lazy = true,
  },
  concurrency = 8,
  dev = {
    pattern = { "Kibadda" },
    path = "~/plugins",
    fallback = true,
  },
  install = {
    missing = false,
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
        vim.ui.open(plugin.url)
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
        "netrwPlugin",
        "rplugin",
        "tarPlugin",
        "tutor",
        "zipPlugin",
      },
    },
  },
})
