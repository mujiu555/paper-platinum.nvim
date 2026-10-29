-- Audit resolved diagnostic virtual text/lines, including real diagnostic extmarks.
vim.opt.rtp:prepend(vim.fn.getcwd())
local theme = require('paper-platinum')
local profiles = require('paper-platinum.contrast').profiles
-- Independent WCAG implementation: do not test the correction with itself.
local function luminance(rgb)
  local sum = 0
  for i, weight in ipairs({ 0.2126, 0.7152, 0.0722 }) do
    local channel = math.floor(rgb / 256 ^ (3 - i)) % 256 / 255
    sum = sum + weight * (channel <= 0.04045 and channel / 12.92 or ((channel + 0.055) / 1.055) ^ 2.4)
  end
  return sum
end
local function ratio(a,b)
  a,b=luminance(a),luminance(b)
  return (math.max(a,b)+0.05)/(math.min(a,b)+0.05)
end
local function hl(name) return vim.api.nvim_get_hl(0,{name=name,link=false}) end
local function hex(n) return n and string.format('#%06x',n) or 'UNKNOWN' end
local report={'Mode | Style | Highlight | Category | Foreground | Background | Ratio | Minimum | Result'}
local checked,unknown=0,0
local function run()
  local buf=vim.api.nvim_create_buf(false,true)
  vim.api.nvim_set_current_buf(buf)
  vim.api.nvim_buf_set_lines(buf,0,-1,false,{'local value = 1','return value'})
  local ns=vim.api.nvim_create_namespace('paper-virtual-text-test')
  for _,style in ipairs({'light','dark'}) do
    for _,mode in ipairs({'reading','high'}) do
      for _,vivid in ipairs({false,true}) do
        for _,transparent in ipairs({false,true}) do
          theme.load({style=style,vivid=vivid,transparent=transparent,ui={contrast=mode}})
          for _,severity in ipairs({'Error','Warn','Info','Hint','Ok'}) do
            for _,prefix in ipairs({'DiagnosticVirtualText','DiagnosticVirtualLines'}) do
              local name=prefix..severity
              local spec=hl(name)
              assert(spec.fg and not spec.bg,name..': foreground required, no colored background')
              local surfaces={Normal=hl('Normal').bg}
              if transparent then
                unknown=unknown+1
                report[#report+1]=table.concat({mode,style,name,'text',hex(spec.fg),'UNKNOWN','N/A',(vivid and profiles[mode].vivid_text or profiles[mode].text),'UNVERIFIABLE'},' | ')
              else
                surfaces.CursorLine=hl('CursorLine').bg
                surfaces.Visual=hl('Visual').bg
                surfaces.DiffAdd=hl('DiffAdd').bg
                surfaces.DiffChange=hl('DiffChange').bg
                surfaces.DiffDelete=hl('DiffDelete').bg
                surfaces.DiffText=hl('DiffText').bg
                for surface,bg in pairs(surfaces) do
                  local value=ratio(spec.fg,bg)
                  local row=table.concat({mode,style,name..'@'..surface,'text',hex(spec.fg),hex(bg),string.format('%.4f',value),(vivid and profiles[mode].vivid_text or profiles[mode].text),value>=(vivid and profiles[mode].vivid_text or profiles[mode].text) and 'PASS' or 'FAIL'},' | ')
                  report[#report+1]=row
                  assert(value>=(vivid and profiles[mode].vivid_text or profiles[mode].text),row)
                  checked=checked+1
                end
              end
            end
          end
          for _,kind in ipairs({'virtual_text','virtual_lines'}) do
            local opts={virtual_text=false,virtual_lines=false,signs=false,underline=false}
            opts[kind]=true
            local diagnostics={}
            for severity=1,4 do diagnostics[#diagnostics+1]={lnum=0,col=0,message='contrast diagnostic',severity=severity} end
            vim.diagnostic.set(ns,buf,diagnostics,opts)
            local found={}
            for _,mark in ipairs(vim.api.nvim_buf_get_extmarks(buf,-1,0,-1,{details=true})) do
              local details=mark[4]
              local lines=kind=='virtual_text' and {details.virt_text or {}} or (details.virt_lines or {})
              for _,line in ipairs(lines) do
                for _,chunk in ipairs(line) do if type(chunk[2])=='string' then found[chunk[2]]=true end end
              end
            end
            for _,severity in ipairs({'Error','Warn','Info','Hint'}) do
              local group=(kind=='virtual_text' and 'DiagnosticVirtualText' or 'DiagnosticVirtualLines')..severity
              assert(found[group],'diagnostic API did not emit '..group)
            end
            vim.diagnostic.reset(ns,buf)
          end
        end
      end
    end
  end
end
local ok,err=xpcall(run,debug.traceback)
vim.fn.writefile(report,'doc/virtual-text-report.txt')
if not ok then print(err); vim.cmd('cquit 1') end
print(string.format('PASS: %d ratios; %d UNVERIFIABLE transparent cases; diagnostic extmarks verified',checked,unknown))
vim.cmd('qa!')
