return {
  debug = "Util::getLogger($0)->debug($1);",
  warn = "Util::getLogger($0)->warn($1);",
  info = "Util::getLogger($0)->info($1);",
  error = "Util::getLogger($0)->error($1);",
  log = "Util::getLogger($0)->${2:debug}($1);",

  set = "public function set$1($0 \\$$1): void {\n\t\\$this->$1 = \\$$1;\n}",
  get = "public function get$1()$0 {\n\treturn \\$this->$1;\n}",

  setget = "public function set$1($2 \\$$1): void {\n\t\\$this->$1 = \\$$1;\n}\n\npublic function get$1(): $2 {\n\treturn \\$this->$1;\n}",
}
