local M = {}
-- Independently tuned warm-paper and warm-charcoal palettes. No inverted RGBs.
M.light = {
  bg = "#f2efe7", bg_alt = "#e8e5dc", bg_highlight = "#dfddd4",
  bg_visual = "#ccd9df", bg_popup = "#e9e7df", bg_float = "#eeece4",
  bg_statusline = "#d6d4cc", fg = "#292a25", fg_alt = "#42443d",
  fg_muted = "#696c63", fg_disabled = "#92948a", border = "#a5a69b",
  border_highlight = "#faf8f0", border_shadow = "#777c72",
  selection = "#315c73", selection_fg = "#f5f2e9", cursorline = "#e8e7de",
  cursor_bg = "#003fba", cursor_fg = "#fffdf7",
  blue = "#315d78", green = "#4b6547", teal = "#366762",
  ochre = "#805d28", brick = "#a04438", purple = "#70566f",
  error = "#a13c32", warning = "#815b20", info = "#3e6277",
  hint = "#596c5b", success = "#46663e", search = "#e4d3a4",
  diff_add = "#dde6d5", diff_change = "#dfe6e7", diff_delete = "#edddd7",
  diff_text = "#c5d5da",
  terminal = { "#3c3d37", "#a04438", "#4b6547", "#805d28", "#315d78", "#70566f", "#366762", "#d6d4cc",
    "#6a6d63", "#b24c3e", "#56734e", "#8c682d", "#3f6c88", "#80617e", "#42766f", "#f2efe7" },
}
M.dark = {
  bg = "#292925", bg_alt = "#30312c", bg_highlight = "#41433b",
  bg_visual = "#45565e", bg_popup = "#373831", bg_float = "#33342e",
  bg_statusline = "#41423a", fg = "#dedbcf", fg_alt = "#c0c1b4",
  fg_muted = "#a2a797", fg_disabled = "#72786b", border = "#686e60",
  border_highlight = "#878c7c", border_shadow = "#1b1d19",
  selection = "#aec5cf", selection_fg = "#272d2d", cursorline = "#34362e",
  cursor_bg = "#dedbcf", cursor_fg = "#292925",
  blue = "#a4bdcc", green = "#b1c19a", teal = "#9ebfb3",
  ochre = "#d0b47e", brick = "#d79d87", purple = "#c2aac1",
  error = "#df9b8c", warning = "#d5bb80", info = "#a6becb",
  hint = "#a6b59b", success = "#b1c69e", search = "#655b3d",
  diff_add = "#364331", diff_change = "#344248", diff_delete = "#4a3530",
  diff_text = "#4c6067",
  terminal = { "#34362e", "#cf9484", "#a2b78e", "#c5aa73", "#95b0c0", "#b59db4", "#90b2a5", "#c3c3b6",
    "#858b7c", "#e0aa98", "#baceaa", "#dfc58e", "#b5ccda", "#d1bbcf", "#afcec0", "#e8e4d8" },
}
function M.get(opts)
  local c = vim.deepcopy(M[opts.style])
  require("paper-platinum.contrast").palette(c, opts)
  if opts.ui.contrast == "high" then
    -- Deliberately vivid, independently designed ink and luminous color palettes.
    local accents = opts.style == "light" and {
      blue = "#005fff", green = "#008c24", teal = "#009c92",
      ochre = "#d47700", brick = "#ef2848", purple = "#bd20df",
    } or {
      blue = "#25ceff", green = "#91ff32", teal = "#00ffd0",
      ochre = "#ffd62b", brick = "#ff7187", purple = "#f097ff",
    }
    for key, value in pairs(accents) do c[key] = value end
  end
  local aliases = {
    keyword = "purple", ["function"] = "blue", method = "blue", variable = "fg",
    parameter = "fg_alt", property = "fg_alt", type = "teal", interface = "teal",
    constant = "ochre", number = "ochre", string = "green", boolean = "ochre",
    operator = "fg_alt", comment = "fg_muted", preprocessor = "purple", macro = "ochre",
    namespace = "teal", attribute = "purple", deprecated = "fg_muted",
  }
  for name, source in pairs(aliases) do c[name] = c[source] end
  if opts.ui.contrast == "high" then
    c.parameter, c.property = c.ochre, c.teal
  end
  if opts.ui.contrast == "normal" then
    -- Legacy high surfaces and prose; deliberately separated semantic accents.
    local accents = opts.style == "light" and {
      blue = "#235c86", green = "#38652e", teal = "#17685f",
      ochre = "#895914", brick = "#a53d31", purple = "#794b80",
      parameter = "#79582f", property = "#32616d",
    } or {
      blue = "#98c6e5", green = "#b0cd8c", teal = "#86cebb",
      ochre = "#e1b86b", brick = "#e4a088", purple = "#d0a4d5",
      parameter = "#d0ba91", property = "#91c7cf",
    }
    for key, value in pairs(accents) do c[key] = value end
    for name, source in pairs(aliases) do
      if name ~= "parameter" and name ~= "property" then c[name] = c[source] end
    end
  end
  if opts.vivid then require("paper-platinum.vivid")(c, opts) end
  if opts.on_colors then opts.on_colors(c) end
  return c
end
return M
