return {
  debug = "Util::getLogger($0)->debug($1);",
  warn = "Util::getLogger($0)->warn($1);",
  info = "Util::getLogger($0)->info($1);",
  error = "Util::getLogger($0)->error($1);",
  log = "Util::getLogger($0)->${2:debug}($1);",

  ["function"] = "${1|public,private,protected|} function $3($4)$5 {\n\t$0\n}",
  static = "${1|public,private,protected|} static function $2($3)$5 {\n\t$0\n}",

  class = "class ${TM_FILENAME_BASE} $1{\n\t$0\n}",
  enum = "enum ${TM_FILENAME_BASE}${1:: int} {\n\t$0\n}",

  foreach = "foreach ($1 as $2) {\n\t$0\n}",
  ["for"] = "for (\\$${1:i} = ${2:0}; \\$$1 $3; \\$$1++) {\n\t$0\n}",
  ["while"] = "while ($1) {\n\t$0\n}",
  ["do"] = "do {\n\t$0\n} while ($1)",

  match = "match ($1) {\n\t$0\n};",

  ["if"] = "if ($1) {\n\t$0\n}",
  ["elseif"] = "else if ($1) {\n\t$0\n}",
  ["else"] = "else {\n\t$0\n}",

  set = "public function set$1($0 \\$$1): void {\n\t\\$this->$1 = \\$$1;\n}",
  get = "public function get$1()$0 {\n\treturn \\$this->$1;\n}",

  setget = "public function set$1($2 \\$$1): void {\n\t\\$this->$1 = \\$$1;\n}\n\npublic function get$1(): $2 {\n\treturn \\$this->$1;\n}",
}
