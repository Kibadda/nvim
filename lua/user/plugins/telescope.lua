return {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    "nvim-telescope/telescope-symbols.nvim",
    "nvim-telescope/telescope-ui-select.nvim",
    "aaronhallaert/ts-advanced-git-search.nvim",
    "nvim-telescope/telescope-file-browser.nvim",
  },
  cmd = "Telescope",
  keys = {
    { "<Leader>f", "<Cmd>Telescope find_files<CR>", desc = "Find Files" },
    { "<Leader>F", "<Cmd>Telescope find_files no_ignore=true hidden=true<CR>", desc = "Find All Files" },
    { "<Leader>b", "<Cmd>Telescope buffers<CR>", desc = "Buffers" },
    { "<Leader>e", "<Cmd>Telescope file_browser<CR>", desc = "Explorer" },
    { "<Leader>E", "<Cmd>Telescope file_browser path=%:p:h select_buffer=true<CR>", desc = "Explorer" },
    { "<Leader>sg", "<Cmd>Telescope live_grep<CR>", desc = "Live Grep" },
    { "<Leader>sh", "<Cmd>Telescope help_tags<CR>", desc = "Help" },
    { "<Leader>sH", "<Cmd>Telescope highlights<CR>", desc = "Highlights" },
    { "<Leader>sr", "<Cmd>Telescope resume<CR>", desc = "Resume" },
    { "<M-e>", "<Cmd>Telescope symbols<CR>", desc = "Emojis", mode = "i" },
  },
  opts = function()
    return {
      defaults = {
        winblend = 0,
        prompt_prefix = "Search: ",
        borderchars = {
          prompt = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
          results = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
          preview = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
        },
        mappings = {
          i = {
            ["<C-j>"] = "move_selection_next",
            ["<C-k>"] = "move_selection_previous",
          },
        },
      },
      extensions = {
        ["ui-select"] = {
          require("telescope.themes").get_dropdown {
            borderchars = {
              prompt = { "─", "│", " ", "│", "┌", "┐", " ", " " },
              results = { "─", "│", "─", "│", "├", "┤", "┘", "└" },
            },
          },
        },
        file_browser = {
          git_status = false,
          mappings = {
            i = {
              ["<C-t>"] = false,
            },
            n = {
              t = false,
            },
          },
        },
      },
    }
  end,
  init = function()
    local group = vim.api.nvim_create_augroup("OpenTelescopeFindFilesIfDirectory", { clear = true })
    vim.api.nvim_create_autocmd("VimEnter", {
      group = group,
      callback = function(data)
        if vim.fn.isdirectory(data.file) == 1 then
          vim.cmd.cd(data.file)
          vim.cmd.argdelete "*"
          vim.cmd.bdelete()
          vim.cmd.Telescope "find_files"
        end
      end,
    })

    vim.api.nvim_create_autocmd("BufEnter", {
      group = group,
      pattern = "*/",
      callback = function(data)
        if vim.fn.isdirectory(data.file) == 1 then
          vim.cmd.bdelete()
          vim.cmd {
            cmd = "Telescope",
            args = { "find_files", "search_dirs=" .. vim.fn.fnamemodify(data.file, ":.") },
          }
        end
      end,
    })

    -- telescope-ui-select is lazy loaded
    -- on first time using vim.ui.select -> also load telescope
    local ui_select = vim.ui.select
    ---@diagnostic disable-next-line: duplicate-set-field
    vim.ui.select = function(...)
      require "telescope"
      ui_select(...)
    end
  end,
  config = function(_, opts)
    require("telescope").setup(opts)
    require("telescope").load_extension "ui-select"
    require("telescope").load_extension "advanced_git_search"
    require("telescope").load_extension "file_browser"

    vim.api.nvim_set_hl(0, "TelescopeTitle", { bg = "#BF7471", fg = "#000000" })
    vim.api.nvim_create_autocmd("Colorscheme", {
      callback = function()
        vim.api.nvim_set_hl(0, "TelescopeTitle", { bg = "#BF7471", fg = "#000000" })
      end,
    })
  end,
}
