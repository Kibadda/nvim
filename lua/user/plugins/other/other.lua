local M = {}

M.setup = function (use)
  -- Google Keep
  use {
    'stevearc/gkeep.nvim',
    config = function ()
      require('telescope').load_extension 'gkeep'
    end,
    run = ':UpdateRemotePlugins',
  }

  -- Google Calendar
  use {
    'itchyny/calendar.vim',
    config = function()
      require('user.plugins.other.calendar')
    end
  }

  -- Testing my own plugin :D
  use {
    'Kibadda/laravel-docs.nvim',
    config = function()
      require('telescope').load_extension 'laraveldocs'
    end
  }

  -- better start and hashtag search
  use { 'nelstrom/vim-visual-star-search' }

  -- easy motion
  use { 'easymotion/vim-easymotion' }

  -- tmux navigation
  -- use { 'christoomey/vim-tmux-navigator' }
end

return M