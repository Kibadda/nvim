return {
  "glacambre/firenvim",
  cond = not not vim.g.started_by_firenvim,
  build = function()
    require("lazy").load { plugins = { "firenvim" }, wait = true }
    vim.fn["firenvim#install"](0)
  end,
  lazy = false,
  init = function()
    vim.g.firenvim_config = {
      localSettings = {
        [".*"] = {
          cmdline = "neovim",
          priority = 0,
          takeover = "once",
        },
        ["https?://.*github.com.*$"] = {
          content = "markdown",
          priority = 1,
        },
        ["https?://git.cortex-media.de.*$"] = {
          content = "markdown",
          priority = 1,
        },
      },
    }

    vim.api.nvim_create_autocmd("UIEnter", {
      group = vim.api.nvim_create_augroup("FirenvimUI", { clear = true }),
      callback = function()
        local client = vim.api.nvim_get_chan_info(vim.v.event.chan).client
        if client ~= nil and client.name == "Firenvim" then
          vim.opt.showtabline = 0
          vim.opt.winbar = nil
          vim.opt.laststatus = 2
          vim.opt.cmdheight = 0
          -- vim.opt.spell = true
          -- vim.opt.spelllang = "de,en"

          vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI" }, {
            callback = function()
              if vim.g.timer_started == true then
                return
              end
              vim.g.timer_started = true
              vim.fn.timer_start(3000, function()
                vim.g.timer_started = false
                vim.cmd "silent! write"
              end)
            end,
          })

          vim.keymap.set("n", "<C-j>", "<Cmd>call firenvim#focus_page()<CR>")
          vim.keymap.set("n", "<C-k>", "<Cmd>call firenvim#focus_page()<CR>")

          vim.cmd.startinsert()
        end
      end,
    })
  end,
}
