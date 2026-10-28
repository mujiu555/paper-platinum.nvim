-- Interactive visual fixture. Run from the repository root; no user config loaded.
vim.opt.rtp:prepend(vim.fn.getcwd())
if vim.env.PAPER_QUERIES then vim.opt.rtp:append(vim.env.PAPER_QUERIES) end
local theme = require('paper-platinum')
theme.setup({ style = vim.env.PAPER_STYLE or 'light', transparent = vim.env.PAPER_TRANSPARENT == '1', ui = { relief = 'subtle' } })
vim.cmd.colorscheme('paper-platinum')
vim.o.number = true
vim.o.cursorline = true
vim.o.signcolumn = 'yes'
vim.o.laststatus = 3
vim.o.showmode = false
vim.o.cmdheight = 1
vim.o.statusline = '  Paper Platinum  |  %f %m %= %l:%c  '
vim.o.fillchars = 'eob: ,vert:│'
vim.o.shortmess = vim.o.shortmess .. 'I'
vim.o.completeopt = 'menu,menuone,noselect'
vim.o.pumheight = 7
vim.o.winblend = 0
vim.o.pumblend = 0
local b = vim.api.nvim_get_current_buf()
vim.api.nvim_buf_set_name(b, 'paper.lua')
vim.api.nvim_buf_set_lines(b, 0, -1, false, {
  '-- Paper Platinum: a quiet working surface',
  'local workstation = {}',
  '',
  '--- Readable paper, precise controls.',
  '---@param name string',
  'function workstation.open(name)',
  '  local width = 80',
  '  local title = "Welcome, " .. name',
  '  local enabled = true',
  '  return title, width, enabled',
  'end',
  '',
  'local result = workstation.open("Platinum")',
  'print(result)',
  '',
  '-- TODO: persist the workspace layout',
  '-- Comments remain legible during long sessions.',
  '',
  '-- Search: title       Selection: distinct blue-grey',
  '',
  '-- E / W / I / H prefixes retain diagnostic meaning.',
  '-- Floating windows keep a solid reading surface.',
})
vim.bo.filetype = 'lua'
vim.treesitter.start(b, 'lua')
local ns = vim.api.nvim_create_namespace('paper-preview')
vim.api.nvim_buf_set_extmark(b, ns, 6, 18, { virt_text = { { ' : integer', 'LspInlayHint' } }, virt_text_pos = 'inline' })
vim.api.nvim_buf_set_extmark(b, ns, 12, 6, { end_col = 12, hl_group = 'Visual' })
vim.fn.setreg('/', 'title')
vim.o.hlsearch = true
vim.diagnostic.config({ virtual_text = { prefix = '', format = function(d) return ({ 'E: ', 'W: ', 'I: ', 'H: ' })[d.severity] .. d.message end }, signs = { text = { [1] = 'E', [2] = 'W', [3] = 'I', [4] = 'H' } }, underline = true })
vim.diagnostic.set(ns, b, {
  { lnum = 7, col = 16, end_col = 23, severity = 2, message = 'check input' },
  { lnum = 13, col = 0, end_col = 5, severity = 1, message = 'example error' },
  { lnum = 19, col = 0, severity = 4, message = 'optional annotation' },
})
vim.cmd('vsplit')
local right = vim.api.nvim_get_current_win()
local rb = vim.api.nvim_create_buf(false, true)
vim.api.nvim_win_set_buf(right, rb)
vim.api.nvim_buf_set_name(rb, 'reader.rs')
vim.api.nvim_buf_set_lines(rb, 0, -1, false, {
  '// Warm charcoal / warm paper share semantics.',
  'use std::io::{self, Read};', '',
  '#[derive(Debug)]',
  'struct Document {',
  '    title: String,',
  '    lines: usize,',
  '}', '',
  'impl Document {',
  '    fn summary(&self) -> String {',
  '        format!("{}: {} lines", self.title, self.lines)',
  '    }',
  '}', '',
  'fn main() -> io::Result<()> {',
  '    let mut text = String::new();',
  '    io::stdin().read_to_string(&mut text)?;',
  '    println!("Read {} bytes", text.len());',
  '    Ok(())',
  '}',
})
vim.bo[rb].filetype = 'rust'
local ok = pcall(vim.treesitter.start, rb, 'rust')
if not ok then vim.cmd('syntax enable') end
vim.cmd('wincmd r')
vim.cmd('wincmd p')
local left = vim.fn.bufwinid(b)
vim.api.nvim_set_current_win(left)
vim.api.nvim_win_set_cursor(left, { 9, 8 })
local fb = vim.api.nvim_create_buf(false, true)
vim.api.nvim_buf_set_lines(fb, 0, -1, false, {
  'workstation.open(name: string)', '',
  'Open a document in the current workspace.',
  'Returns a title, width and enabled state.', '',
  'Paper surface / restrained border / clear focus',
})
vim.api.nvim_open_win(fb, false, { relative = 'editor', row = 25, col = 12, width = 52, height = 6, style = 'minimal', border = theme.border(), title = ' Documentation ', title_pos = 'left' })
vim.api.nvim_buf_set_extmark(fb, ns, 0, 0, { end_row = 1, end_col = 0, hl_group = 'Function' })
vim.api.nvim_buf_set_extmark(fb, ns, 5, 0, { end_row = 6, end_col = 0, hl_group = 'Comment' })
-- A real native completion menu, with the actual Pmenu/PmenuSel rendering path.
vim.defer_fn(function()
  vim.cmd('startinsert')
  vim.defer_fn(function()
    vim.fn.complete(vim.fn.col('.'), {
      { word = 'enabled', abbr = 'enabled', kind = 'Variable', menu = '[buffer]' },
      { word = 'open', abbr = 'open(name)', kind = 'Function', menu = '[LSP]' },
      { word = 'Document', abbr = 'Document', kind = 'Type', menu = '[LSP]' },
    })
  end, 150)
end, 200)
