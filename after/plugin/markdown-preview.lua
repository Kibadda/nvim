RegisterKeymaps("n", "<Leader>", {
  m = {
    name = "Markdown",
    p = { "<Plug>MarkdownPreview", "Start" },
    s = { "<Plug>MarkdownPreviewStop", "Stop" },
    t = { "<Plug>MarkdownPreviewToggle", "Toggle" },
  },
})