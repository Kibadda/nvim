return {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    "nvim-telescope/telescope-symbols.nvim",
    "nvim-telescope/telescope-ui-select.nvim",
    "aaronhallaert/ts-advanced-git-search.nvim",
  },
  cmd = "Telescope",
  opts = function()
    return {
      defaults = {
        sorting_strategy = "ascending",
        layout_strategy = "bottom_pane",
        winblend = 0,
        prompt_prefix = "Search: ",
        results_title = false,
        borderchars = {
          prompt = { "─", "│", " ", "│", "┌", "┐", " ", " " },
          results = { " ", " ", "─", "│", " ", " ", "─", "└" },
          preview = { "─", "│", "─", "│", "┌", "┤", "┘", "┴" },
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
      },
    }
  end,
  init = function()
    require("user.utils").keymaps {
      n = {
        ["<Leader>"] = {
          f = { "<Cmd>Telescope find_files<CR>", "Find Files" },
          F = { "<Cmd>Telescope find_files no_ignore=true hidden=true<CR>", "Find All Files" },
          b = { "<Cmd>Telescope buffers<CR>", "Buffers" },
          s = {
            name = "Search",
            g = { "<Cmd>Telescope live_grep<CR>", "Live Grep" },
            h = { "<Cmd>Telescope help_tags<CR>", "Help" },
            b = { "<Cmd>Telescope builtin<CR>", "Builtin" },
            k = { "<Cmd>Telescope keymaps<CR>", "Keymaps" },
            H = { "<Cmd>Telescope highlights<CR>", "Highlights" },
            r = { "<Cmd>Telescope registers<CR>", "Registers" },
            c = { "<Cmd>Telescope commands<CR>", "Commands" },
            R = { "<Cmd>Telescope resume<CR>", "Resume" },
          },
        },
      },
      i = {
        ["<M-e>"] = { "<Cmd>Telescope symbols<CR>", "Emojis" },
      },
    }

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
    vim.ui.select = function(...)
      require "telescope"
      vim.ui.select(...)
    end
  end,
  config = function(_, opts)
    require("telescope").setup(opts)
    require("telescope").load_extension "ui-select"
    require("telescope").load_extension "advanced_git_search"
  end,
}
