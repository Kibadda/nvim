return {
  "Kibadda/projectodo.nvim",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "tpope/vim-dotenv",
    "nvim-lua/plenary.nvim",
    "Kibadda/session.nvim",
  },
  dev = true,
  opts = {
    sources = {
      git = {
        enabled = vim.env.LOCATION == "work",
        url = "https://git.cortex-media.de/api/v4/projects/197/issues?state=opened",
        ignore_labels = { "Montag", "Dienstag", "Mittwoch", "Donnerstag", "Freitag" },
        force = false,
        cache = "/tmp/projectodo.json",
        uses_session = true,
        adapter = "gitlab",
        filter = function(issue)
          local weekday = tonumber(os.date "%w")
          local label
          if weekday == 1 then
            label = "Montag"
          elseif weekday == 2 then
            label = "Dienstag"
          elseif weekday == 3 then
            label = "Mittwoch"
          elseif weekday == 4 then
            label = "Donnerstag"
          elseif weekday == 5 then
            label = "Freitag"
          else
            return false
          end

          return vim.tbl_contains(issue.labels, label)
        end,
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
            require("session").load(table.remove(vim.split(session, "/")))
          end
        end,
      },
    },
  },
  init = function()
    vim.api.nvim_create_user_command("ProjectodoClearCache", function()
      local config = require "projectodo.config"
      if vim.fn.filereadable(config.options.sources.git.cache) == 1 then
        vim.system { "rm", config.options.sources.git.cache }
      end
    end, { nargs = 0, bang = false })
  end,
}
