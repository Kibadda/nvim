return {
  "jwalton512/vim-blade",
  enabled = false,
  ft = "blade",
  opts = {
    custom_directives = {
      "routes",
      "vite",
      "intertiaHead",
      "interia",
    },
  },
  config = function(_, opts)
    require("user.utils").set_global_options(opts, "blade")
  end,
}
