return {
  "hrsh7th/nvim-cmp",
  dependencies = {
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-nvim-lsp",
    "onsails/lspkind.nvim",
  },
  event = "InsertEnter",
  opts = function()
    local cmp = require "cmp"
    local lspkind = require "lspkind"

    cmp.register_source("snippets", require "user.snippets")

    local function has_words_before()
      unpack = unpack or table.unpack
      local line, col = unpack(vim.api.nvim_win_get_cursor(0))
      return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match "%s" == nil
    end

    local window_options = {
      border = "single",
      scrolloff = 1,
      col_offset = -3,
    }
    return {
      experimental = {
        ghost_text = false,
      },
      formatting = {
        fields = { "kind", "abbr", "menu" },
        format = function(entry, vim_item)
          local kind = lspkind.cmp_format { mode = "symbol_text", maxwidth = 50 }(entry, vim_item)
          local strings = vim.split(kind.kind, "%s", { trimempty = true })
          kind.kind = strings[1] or ""
          kind.menu = strings[2] or ""
          return kind
        end,
      },
      window = {
        completion = cmp.config.window.bordered(window_options),
        documentation = cmp.config.window.bordered(window_options),
      },
      snippet = {
        expand = function(args)
          vim.snippet.expand(args.body)
        end,
      },
      sources = cmp.config.sources({
        { name = "nvim_lsp" },
        { name = "path" },
        { name = "snippets" },
      }, {
        { name = "buffer" },
      }),
      completion = {
        completeopt = "menu,menuone,noinsert,noselect,preview",
      },
      mapping = cmp.mapping.preset.insert {
        ["<CR>"] = cmp.mapping.confirm { select = false },
        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          elseif has_words_before() then
            cmp.complete()
          else
            fallback()
          end
        end, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          else
            fallback()
          end
        end, { "i", "s" }),
        ["<C-l>"] = cmp.mapping(function(fallback)
          if vim.snippet.jumpable(1) then
            vim.snippet.jump(1)
          else
            fallback()
          end
        end, { "i", "s" }),
        ["<C-h>"] = cmp.mapping(function(fallback)
          if vim.snippet.jumpable(-1) then
            vim.snippet.jump(-1)
          else
            fallback()
          end
        end, { "i", "s" }),
        ["<C-k>"] = cmp.mapping.scroll_docs(-4),
        ["<C-j>"] = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.complete(),
      },
    }
  end,
}
