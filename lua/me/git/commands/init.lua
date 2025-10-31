local commands = {
  status = require "me.git.commands.status",
}

local base = require "me.git.commands.base"

for key, command in pairs(commands) do
  commands[key] = base.new(command)
end

return commands
