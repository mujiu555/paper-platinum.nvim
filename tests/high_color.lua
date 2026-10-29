vim.opt.rtp:prepend(vim.fn.getcwd())
local theme=require('paper-platinum')
local contrast=require('paper-platinum.contrast')
local previous = {
 light = { ['@function']='#0044b4', ['@type']='#005752', ['@keyword']='#820a9e', ['@string']='#005a13', ['@number']='#833600' },
 dark = { ['@function']='#38b5ff', ['@type']='#26e6c1', ['@keyword']='#e478ff', ['@string']='#80ed44', ['@number']='#ffc239' },
}
for _,style in ipairs({'light','dark'}) do
 theme.load({style=style,ui={contrast='high'}})
 local h,c=theme.highlights()
 for _,name in ipairs({'@function','@type','@keyword','@string','@number','@variable.parameter','@variable.member','@lsp.type.class','@lsp.type.property'}) do
  local s=vim.api.nvim_get_hl(0,{name=name,link=false})
  local r=math.floor(s.fg/65536); local g=math.floor(s.fg/256)%256; local b=s.fg%256
  assert(math.max(r,g,b)-math.min(r,g,b)>=80,name..' lost chroma')
  if previous[style][name] then
   assert(contrast.luminance(string.format('#%06x',s.fg)) > contrast.luminance(previous[style][name]),name..' must be brighter')
  end
  print(style..' '..name..' '..string.format('#%06x',s.fg))
 end
 for _,name in ipairs({'Normal','NormalNC','NormalFloat','Identifier'}) do
  local s=vim.api.nvim_get_hl(0,{name=name,link=false})
  for _,bg in ipairs({c.bg,c.bg_float,c.bg_visual,c.cursorline,c.diff_text}) do
   assert(contrast.ratio(string.format('#%06x',s.fg),bg)>=contrast.profiles.high.body,name..' body contrast')
  end
 end
end
print('PASS: vivid high semantic colors and 14:1 body text')
vim.cmd('qa!')
