-- Public highlight names; provenance and support scope: doc/SOURCES.md.
return function(c)
  return {
    WhichKey = { link = "Function" },
    WhichKeyGroup = { link = "Keyword" },
    WhichKeyDesc = { fg = c.fg },
    WhichKeySeparator = { link = "Comment" },
    WhichKeyValue = { link = "Comment" },
    WhichKeyNormal = { link = "NormalFloat" },
    WhichKeyBorder = { link = "FloatBorder" },
    WhichKeyTitle = { link = "FloatTitle" },
  }
end
