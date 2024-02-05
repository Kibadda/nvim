return function(_, start_opts)
  return MiniPick.builtin.cli(
    {
      command = {
        "rg",
        "--files",
        "--no-follow",
        "--color=never",
        "--hidden",
        "--no-ignore-vcs",
      },
      postprocess = function(items)
        return vim.tbl_filter(function(item)
          return item ~= "" and not vim.startswith(item, ".git/")
        end, items)
      end,
    },
    vim.tbl_deep_extend("force", {
      source = {
        name = "All Files (rg)",
        show = function(b, i, q)
          MiniPick.default_show(b, i, q, { show_icons = true })
        end,
      },
    }, start_opts or {})
  )
end
