return function(c, o)
  local style = require("paper-platinum.util").style
  local h = {
    Comment = style({ fg = c.comment }, o.styles.comments),
    Constant = { fg = c.constant }, String = { fg = c.string }, Character = { fg = c.string },
    Number = { fg = c.number }, Boolean = { fg = c.boolean }, Float = { fg = c.number },
    Identifier = style({ fg = c.variable }, o.styles.variables),
    Function = style({ fg = c["function"] }, o.styles.functions),
    Keyword = style({ fg = c.keyword }, o.styles.keywords),
    Operator = { fg = c.operator }, PreProc = { fg = c.preprocessor }, Macro = { fg = c.macro },
    Type = { fg = c.type }, Special = { fg = c.attribute }, Delimiter = { fg = c.fg_alt },
    Todo = { fg = c.ochre, bold = true, underline = true },
    Error = { fg = c.error, bold = true, underline = true },
    Underlined = { fg = c.blue, underline = true }, Ignore = { fg = c.fg_disabled },
    PaperParameter = { fg = c.parameter }, PaperProperty = { fg = c.property },
    PaperNamespace = { fg = c.namespace }, PaperInterface = { fg = c.interface },
    PaperMethod = style({ fg = c.method }, o.styles.functions),
    PaperDeprecated = { fg = c.deprecated, strikethrough = true },
  }
  local link = require("paper-platinum.util").links
  link(h, "Statement Conditional Repeat Label Exception", "Keyword")
  link(h, "Include Define PreCondit", "PreProc")
  link(h, "StorageClass Structure Typedef", "Type")
  link(h, "SpecialChar Tag Debug", "Special")
  link(h, "SpecialComment", "Comment")
  return h
end
