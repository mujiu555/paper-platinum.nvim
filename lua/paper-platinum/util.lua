local M = {}
function M.style(base, extra)
  return vim.tbl_extend("force", base, extra)
end
function M.links(h, names, target)
  for name in names:gmatch("%S+") do h[name] = { link = target } end
end
function M.transparent(opts, surface)
  if type(opts.transparent) == "boolean" then return opts.transparent end
  return opts.transparent[surface] == true
end
return M
