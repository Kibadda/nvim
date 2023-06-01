return {
  "Kibadda/projectodo.nvim",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "tpope/vim-dotenv",
  },
  dev = true,
  opts = {
    sources = {
      git = {
        enabled = vim.env.LOCATION == "work",
        url = "https://git.cortex-media.de/api/v4/projects/197/issues?state=opened",
        ignore_labels = { "Doing" },
        force = false,
        uses_session = true,
        adapter = "gitlab",
      },
      treesitter = {
        enabled = false,
        dir = "$HOME/notes",
        header = "Current projects",
        main = "index",
        filetype = "norg",
      },
      session = {
        enabled = true,
        load_action = function(session)
          return function()
            require("session.core").load(table.remove(vim.split(session, "/")))
          end
        end,
      },
    },
  },
  init = function()
    vim.api.nvim_create_user_command("ProjectodoClearCache", function()
      local config = require "projectodo.config"
      if vim.fn.filereadable(config.options.sources.git.cache) == 1 then
        os.remove(config.options.sources.git.cache)
      end
    end, { nargs = 0, bang = false })
  end,
}
