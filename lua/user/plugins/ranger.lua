return {
  "kelly-lin/ranger.nvim",
  lazy = false,
  keys = {
    {
      "<Leader>e",
      function()
        require("ranger-nvim").open(true)
      end,
      desc = "Explorer current file",
    },
    {
      "<Leader>E",
      function()
        require("ranger-nvim").open(false)
      end,
      desc = "Explorer",
    },
  },
  init = function()
    local group = vim.api.nvim_create_augroup("OpenExplorerFindFilesIfDirectory", { clear = true })
    vim.api.nvim_create_autocmd("VimEnter", {
      group = group,
      callback = function(data)
        if vim.fn.isdirectory(data.file) == 1 then
          vim.cmd.cd(data.file)
          vim.cmd.argdelete "*"
          vim.cmd.bdelete()
          require("ranger-nvim").open(false)
        end
      end,
    })

    vim.api.nvim_create_autocmd("BufEnter", {
      group = group,
      pattern = "*/",
      callback = function(data)
        if vim.fn.isdirectory(data.file) == 1 then
          vim.cmd.bdelete()
          -- TODO: currently not working with directory path
          require("ranger-nvim").open(false)
        end
      end,
    })
  end,
}
