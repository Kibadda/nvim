vim.pack.add({ "https://github.com/Kibadda/fake.nvim" }, { load = true })

if vim.g.loaded_plugin_fake then
  return
end

vim.g.loaded_plugin_fake = 1

--- @type fake.config
vim.g.fake = {
  {
    filetype = "php",
    snippets = {
      debug = "Util::getLogger()->debug($0);",
      gst = "public function get$2(): $3 {\n\treturn \\$this->$1;\n}\n\npublic function set$2($3 \\$$1): void {\n\t\\$this->$1 = \\$$1;\n}",
      gs = "public function get$2() {\n\treturn \\$this->$1;\n}\n\npublic function set$2($$1) {\n\t\\$this->$1 = \\$$1;\n}",
    },
  },
  {
    filetype = { "javascript", "typescript" },
    snippets = {
      log = "console.log($0);",
    },
  },
}
