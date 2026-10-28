vim.opt.rtp:prepend(vim.fn.getcwd())
if vim.env.PAPER_QUERIES then vim.opt.rtp:append(vim.env.PAPER_QUERIES) end
require('paper-platinum').setup({ style = vim.env.PAPER_STYLE or 'light' })
vim.cmd.colorscheme('paper-platinum')
vim.o.number = true
vim.o.laststatus = 2
vim.o.statusline = ' %f %= %l:%c '
vim.o.showmode = false
vim.o.fillchars = 'eob: ,vert:│'
local cases = { { 'rs', 'rust' }, { 'c', 'c' }, { 'cpp', 'cpp' }, { 'lua', 'lua' }, { 'py', 'python' }, { 'sh', 'bash' }, { 'md', 'markdown' }, { 'json', 'json' }, { 'yaml', 'yaml' }, { 'diff', 'diff' } }
vim.cmd('vsplit')
local columns = vim.api.nvim_tabpage_list_wins(0)
local wins = {}
for _, col in ipairs(columns) do
  vim.api.nvim_set_current_win(col)
  for _ = 1, 4 do vim.cmd('split') end
end
for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do wins[#wins + 1] = win end
for i, case in ipairs(cases) do
  local b = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_win_set_buf(wins[i], b)
  vim.api.nvim_buf_set_name(b, 'example.' .. case[1])
  vim.api.nvim_buf_set_lines(b, 0, -1, false, vim.fn.readfile('tests/fixtures/example.' .. case[1]))
  vim.bo[b].filetype = case[2]
  pcall(vim.treesitter.start, b, case[2])
end
vim.cmd('wincmd =')
