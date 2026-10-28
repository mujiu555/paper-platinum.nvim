-- Public highlight names; provenance and support scope: doc/SOURCES.md.
return function(c, o)
  local sidebar_bg = require("paper-platinum.util").transparent(o, "sidebars") and "NONE" or c.bg_float
  return {
    TroubleNormal = { fg = c.fg, bg = sidebar_bg },
    TroubleNormalNC = { fg = c.fg, bg = sidebar_bg },
    TroubleText = { fg = c.fg },
    TroublePreview = { link = "Visual" },
    TroubleFilename = { link = "Directory" },
    TroubleDirectory = { link = "Directory" },
    TroubleSource = { link = "Comment" },
    TroubleCode = { link = "Special" },
    TroublePos = { link = "LineNr" },
    TroubleCount = { link = "Number" },
    TroubleIndent = { link = "NonText" },
  }
end
