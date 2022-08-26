_ = vim.cmd.packadd "packer.nvim"
_ = vim.cmd.packadd "vimball"

return require("packer").startup {
  function(use)
    use "wbthomason/packer.nvim"
    use "kyazdani42/nvim-web-devicons"
    use "nvim-lua/plenary.nvim"

    use "tjdevries/colorbuddy.nvim"
    use "tjdevries/gruvbuddy.nvim"
    use "nvim-lualine/lualine.nvim"
    use "akinsho/bufferline.nvim"
    use "rcarriga/nvim-notify"
    use "mhinz/vim-startify"
    use "alexghergh/nvim-tmux-navigation"
    use "folke/which-key.nvim"
    use "numToStr/Comment.nvim"
    use "tpope/vim-repeat"
    use "fladson/vim-kitty"
    use "kylechui/nvim-surround"
    use "nvim-treesitter/nvim-treesitter"
    use "nvim-treesitter/playground"
    use "nvim-telescope/telescope.nvim"
    use "nvim-telescope/telescope-ui-select.nvim"
    use "nvim-telescope/telescope-fzy-native.nvim"
    -- use "nvim-telescope/telescope-file-browser.nvim"
    use "lewis6991/gitsigns.nvim"
    use "antoinemadec/FixCursorHold.nvim"
    use "sickill/vim-pasta"
    use "AndrewRadev/splitjoin.vim"
    use "windwp/nvim-autopairs"
    use "norcalli/nvim-colorizer.lua"
    use "folke/todo-comments.nvim"
    use "folke/zen-mode.nvim"
    use "folke/twilight.nvim"
    use "karb94/neoscroll.nvim"
    use "phaazon/mind.nvim"
    use "MunifTanjim/nui.nvim"
    use "VonHeikemen/searchbox.nvim"
    use "VonHeikemen/fine-cmdline.nvim"
    use "kevinhwang91/nvim-bqf"
    use "romainl/vim-qf"
    use "kevinhwang91/rnvimr"

    use "hrsh7th/nvim-cmp"
    use "hrsh7th/cmp-path"
    use "hrsh7th/cmp-buffer"
    use "hrsh7th/cmp-nvim-lsp"
    use "L3MON4D3/LuaSnip"
    use "saadparwaiz1/cmp_luasnip"
    use "williamboman/mason.nvim"
    use "williamboman/mason-lspconfig.nvim"
    use "neovim/nvim-lspconfig"
    use "jose-elias-alvarez/null-ls.nvim"
    use "folke/lua-dev.nvim"
  end,
  config = {
    luarocks = {
      python_cmd = "python3",
    },
  },
}
