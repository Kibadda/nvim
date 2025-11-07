local commands = {
  add = require "me.git.commands.add",
  commit = require "me.git.commands.commit",
  diff = require "me.git.commands.diff",
  log = require "me.git.commands.log",
  merge = require "me.git.commands.merge",
  pull = require "me.git.commands.pull",
  push = require "me.git.commands.push",
  rebase = require "me.git.commands.rebase",
  restore = require "me.git.commands.restore",
  stash = require "me.git.commands.stash",
  status = require "me.git.commands.status",
  switch = require "me.git.commands.switch",
}

local base = require "me.git.commands.base"

for key, command in pairs(commands) do
  commands[key] = base.new(command)
end

return commands
