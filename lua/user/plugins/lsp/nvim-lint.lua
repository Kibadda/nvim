require('lint').linters_by_ft = {
  php = {'phpcs'}
}

local phpcs = require('lint.linters.phpcs')
phpcs.args = {
  '-q',
  '--standard=~/.config/nvim/lua/user/external/ruleset.xml',
  '--report=json',
  '-',
}
