local fmt = require("luasnip.extras.fmt").fmt
local s = require("luasnip.nodes.snippet").S
local i = require("luasnip.nodes.insertNode").I

return {
  s(
    "lfun",
    fmt(
      [[
        local function {}({})
          {}
        end
      ]],
      { i(1, "name"), i(2, "params"), i(0) }
    )
  ),
  s(
    "fun",
    fmt(
      [[
        function {}({})
          {}
        end
      ]],
      { i(1, "name"), i(2, "params"), i(0) }
    )
  ),
  s(
    "if",
    fmt(
      [[
        if {} then
          {}
        end
      ]],
      { i(1, "true"), i(0) }
    )
  ),
  s(
    "ife",
    fmt(
      [[
        if {} then
          {}
        else
          {}
        end
      ]],
      { i(1, "true"), i(2), i(0) }
    )
  ),
  s(
    "elif",
    fmt(
      [[
        elseif {} then
          {}
      ]],
      { i(1, "true"), i(0) }
    )
  ),
  s(
    "while",
    fmt(
      [[
        while {} do
          {}
        end
      ]],
      { i(1, "true"), i(0) }
    )
  ),
  s(
    "for",
    fmt(
      [[
        for {} = {}, {} do
          {}
        end
      ]],
      { i(1, "i"), i(2, "1"), i(3, "10"), i(0) }
    )
  ),
  s(
    "fori",
    fmt(
      [[
        for {} in {} do
          {}
        end
      ]],
      { i(1, "_, v"), i(2), i(0) }
    )
  ),
  s(
    "pcall",
    fmt(
      [[
        local ok, {} = pcall({})
      ]],
      { i(1, "_"), i(0) }
    )
  ),
}, {}
