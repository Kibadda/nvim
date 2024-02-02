return {
  "nvim-treesitter/nvim-treesitter",
  lazy = false,
  build = ":TSUpdate",
  dependencies = {
    "nvim-treesitter/nvim-treesitter-textobjects",
    "windwp/nvim-ts-autotag",
    "luckasRanarison/tree-sitter-hypr",
  },
  opts = {
    ensure_installed = {
      "javascript",
      "json",
      "jsonc",
      "typescript",
      "css",
      "php",
      "phpdoc",
      "html",
      "sql",
      "http",
      "regex",
      "gitcommit",
      "gitignore",
      "gitattributes",
      "git_rebase",
      "git_config",
      "toml",
    },
    highlight = {
      enable = true,
    },
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = "<C-Space>",
        node_incremental = "<C-Space>",
        node_decremental = "<C-BS>",
      },
    },
    indent = {
      enable = true,
    },
    autotag = {
      enable = true,
      filetypes = {
        "html",
        "smarty",
      },
    },
    textobjects = {
      select = {
        enable = true,
        lookahead = true,
        keymaps = {
          ["af"] = { query = "@function.outer", desc = "outer function" },
          ["if"] = { query = "@function.inner", desc = "inner function" },
          ["aa"] = { query = "@parameter.outer", desc = "outer function argument" },
          ["ia"] = { query = "@parameter.inner", desc = "inner function argument" },
        },
        selection_modes = {
          ["@function.outer"] = "V",
          ["@function.inner"] = "V",
        },
      },
      move = {
        enable = true,
        set_jumps = true,
        goto_next_start = {
          ["]a"] = "@parameter.inner",
        },
        goto_next_end = {
          ["]A"] = "@parameter.inner",
        },
        goto_previous_start = {
          ["[a"] = "@parameter.inner",
        },
        goto_previous_end = {
          ["[A"] = "@parameter.inner",
        },
      },
    },
  },
  config = function(_, opts)
    ---@type table<string,ParserInfo>
    local parsers = require("nvim-treesitter.parsers").get_parser_configs()

    parsers.smarty = {
      install_info = {
        -- url = "https://github.com/Kibadda/tree-sitter-smarty",
        url = "/home/michael/plugins/tree-sitter-smarty",
        files = { "src/parser.c" },
        branch = "main",
      },
      filetype = "smarty",
      maintainers = { "Kibadda" },
    }

    parsers.snippets = {
      install_info = {
        url = "https://github.com/Kibadda/tree-sitter-snippets",
        -- url = "/home/michael/plugins/tree-sitter-snippets",
        files = { "src/parser.c" },
        branch = "main",
      },
      filetype = "snippets",
      maintainers = { "Kibadda" },
    }

    parsers.hypr = {
      install_info = {
        url = "https://github.com/luckasRanarison/tree-sitter-hypr",
        files = { "src/parser.c" },
        branch = "master",
      },
      filetype = "hypr",
      maintainers = { "luckasRanarison" },
    }

    require("nvim-treesitter.configs").setup(opts)
  end,
}
