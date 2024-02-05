return function(local_opts, start_opts)
  start_opts = start_opts or {}
  start_opts.mappings = {
    explorer = {
      char = "<C-n>",
      func = function()
        require "mini.extra"
        MiniPick.registry.explorer()
        return true
      end,
    },
  }

  return MiniPick.builtin.files(local_opts, start_opts)
end
