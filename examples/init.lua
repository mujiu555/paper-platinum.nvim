-- Install Paper Platinum on runtimepath before running this configuration.
local paper = require('paper-platinum')
paper.setup({
  style = 'light',
  transparent = false, -- set true to inherit your Kitty background
  vivid = false, -- true: full VS Code HC-inspired semantic colors
  terminal_colors = true,
  ui = { relief = 'subtle', contrast = 'normal', borders = true, float_style = 'platinum' },
  styles = { comments = { italic = true }, keywords = { bold = false }, functions = {}, variables = {} },
})
vim.cmd.colorscheme('paper-platinum')
vim.opt.cursorline = true
vim.opt.number = true
vim.opt.signcolumn = 'yes'

-- A theme supplies colors, while your configuration supplies windows and signs.
vim.diagnostic.config({
  virtual_text = {
    prefix = '',
    format = function(d) return ({ 'E: ', 'W: ', 'I: ', 'H: ' })[d.severity] .. d.message end,
  },
  signs = { text = { [1] = 'E', [2] = 'W', [3] = 'I', [4] = 'H' } },
  float = { border = paper.border(), source = true },
})
vim.keymap.set('n', 'K', function() vim.lsp.buf.hover({ border = paper.border() }) end)
vim.keymap.set('n', '<leader>k', function() vim.lsp.buf.signature_help({ border = paper.border() }) end)

-- Optional, inside the relevant plugin's own setup:
-- require('cmp').setup({ window = {
--   completion = require('cmp').config.window.bordered({ border = paper.border(),
--     winhighlight = 'Normal:Pmenu,FloatBorder:FloatBorder,CursorLine:PmenuSel,Search:None' }),
--   documentation = require('cmp').config.window.bordered({ border = paper.border(),
--     winhighlight = 'Normal:NormalFloat,FloatBorder:FloatBorder,Search:None' }),
-- } })
-- require('blink.cmp').setup({ completion = {
--   menu = { border = paper.border() }, documentation = { window = { border = paper.border() } },
-- }, signature = { window = { border = paper.border() } } })
-- require('lualine').setup({ options = { theme = 'paper-platinum' } })

-- Contrast: low (legacy normal), normal (enhanced legacy high, default),
-- reading (10/5/4), high (body 14, colored syntax 4.5, UI 8, comments 6): text / UI / comments.
-- Transparent desktop backgrounds cannot be contrast-certified.
-- reading + vivid: body 10:1; colorful syntax 4.5:1; UI 5:1; comments 4:1.
