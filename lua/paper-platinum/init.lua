local M = {}
local config = require("paper-platinum.config")
function M.setup(opts) config.setup(opts) end
function M.colors() return require("paper-platinum.palette").get(config.get()) end
function M.highlights(opts)
  local o = opts and config.resolve(opts) or config.get()
  local c = require("paper-platinum.palette").get(o)
  local h = {}
  for _, name in ipairs({ "editor", "syntax", "treesitter", "lsp", "diagnostics" }) do
    if o.integrations[name] ~= false then
      h = vim.tbl_extend("force", h, require("paper-platinum.highlights." .. name)(c, o))
    end
  end
  h = vim.tbl_extend("force", h, require("paper-platinum.integrations").get(c, o))
  require("paper-platinum.contrast").apply(h, c, o)
  if o.on_highlights then o.on_highlights(h, c) end
  return h, c, o
end
function M.load(opts)
  assert(vim.fn.has("nvim-0.11") == 1, "paper-platinum requires Neovim 0.11+")
  -- Build before clearing, so errors in configuration callbacks don't erase the active theme.
  if opts then M.setup(opts) end
  local h, c, o = M.highlights()
  vim.g.colors_name = nil
  vim.o.background = o.style
  vim.cmd("highlight clear")
  vim.o.termguicolors = true
  for name, spec in pairs(h) do vim.api.nvim_set_hl(0, name, spec) end
  if o.terminal_colors then
    for i, color in ipairs(c.terminal) do vim.g["terminal_color_" .. (i - 1)] = color end
  end
  vim.g.colors_name = "paper-platinum"
end
-- Explicitly opt in at the window/plugin API. A colorscheme cannot add borders.
function M.border()
  local o = config.get()
  if not o.ui.borders then return "none" end
  local light = o.ui.relief == "flat" and "FloatBorder" or "PaperBorderLight"
  local shadow = o.ui.relief == "flat" and "FloatBorder" or "PaperBorderShadow"
  return { { "┌", light }, { "─", light }, { "┐", light }, { "│", shadow },
    { "┘", shadow }, { "─", shadow }, { "└", shadow }, { "│", light } }
end
return M
