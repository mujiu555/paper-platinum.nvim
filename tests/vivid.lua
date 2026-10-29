vim.opt.rtp:prepend(vim.fn.getcwd())
local theme=require('paper-platinum')
local function resolved(name) return vim.api.nvim_get_hl(0,{name=name,link=false}) end
local pairs_to_check={
 {'@variable','Identifier'}, {'@variable.parameter','PaperParameter'},
 {'@variable.member','PaperProperty'}, {'@function','Function'}, {'@function.method','PaperMethod'},
 {'@lsp.type.function','Function'}, {'@lsp.type.method','PaperMethod'},
 {'@lsp.type.class','Type'}, {'@lsp.type.interface','PaperInterface'},
 {'@lsp.type.namespace','PaperNamespace'}, {'@lsp.type.property','PaperProperty'},
 {'@lsp.type.parameter','PaperParameter'},
}
for _,mode in ipairs({'low','normal','reading','high'}) do
 for _,style in ipairs({'light','dark'}) do
  local base=theme.highlights({style=style,ui={contrast=mode}})
  theme.load({style=style,vivid=true,ui={contrast=mode}})
  local colors={}
  for _,name in ipairs({'Identifier','Function','PaperMethod','Type','PaperInterface','PaperNamespace','PaperParameter','PaperProperty','String','Number','Boolean','Constant','Keyword','Operator','Macro','Special','Comment'}) do
   local fg=resolved(name).fg
   assert(fg,name..' missing')
   colors[fg]=true
   assert(fg~=tonumber(base[name].fg:sub(2),16),name..' vivid unchanged')
   if mode=='reading' then
    local r,g,b=math.floor(fg/65536),math.floor(fg/256)%256,fg%256
    assert(math.max(r,g,b)-math.min(r,g,b)>=60,name..' reading lost chroma')
    local contrast=require('paper-platinum.contrast')
    local c=theme.colors()
    local minimum=name=='Comment' and contrast.profiles.reading.comment or contrast.profiles.reading.vivid_text
    for _,surface in ipairs({'bg','bg_float','bg_popup','cursorline','bg_visual','diff_add','diff_change','diff_delete','diff_text','search'}) do
     assert(contrast.ratio(string.format('#%06x',fg),c[surface])>=minimum,name..' on '..surface)
    end
   end
  end
  assert(vim.tbl_count(colors)>=15,'semantic colors collapsed')
  for _,pair in ipairs(pairs_to_check) do assert(resolved(pair[1]).fg==resolved(pair[2]).fg,'semantic mapping '..pair[1]) end
  assert(not resolved('@lsp.type.variable').fg,'LSP must preserve finer Tree-sitter captures')
  for _,severity in ipairs({'Error','Warn','Info','Hint','Ok'}) do
   assert(resolved('DiagnosticVirtualText'..severity).fg==resolved('Diagnostic'..severity).fg,'vivid diagnostic severity')
  end
  assert(resolved('Normal').fg==tonumber(base.Normal.fg:sub(2),16),'vivid body unchanged')
  print('PASS '..style..'/'..mode..': '..vim.tbl_count(colors)..' semantic colors, Tree-sitter/LSP links')
 end
end
vim.cmd('qa!')
