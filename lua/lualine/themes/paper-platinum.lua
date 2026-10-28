local c = require("paper-platinum").colors()
local function mode(accent)
  return { a = { fg = c.selection_fg, bg = accent, gui = "bold" },
    b = { fg = c.fg, bg = c.bg_statusline }, c = { fg = c.fg_alt, bg = c.bg_alt } }
end
return { normal = mode(c.selection), insert = mode(c.green), visual = mode(c.purple),
  replace = mode(c.brick), command = mode(c.ochre), terminal = mode(c.teal),
  inactive = { a = { fg = c.fg_muted, bg = c.bg_alt }, b = { fg = c.fg_muted, bg = c.bg_alt }, c = { fg = c.fg_muted, bg = c.bg_alt } } }
