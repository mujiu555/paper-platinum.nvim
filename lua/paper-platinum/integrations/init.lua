local M = {}
local names = { "cmp", "blink", "telescope", "fzf", "nvim_tree", "neo_tree", "oil", "gitsigns", "diffview", "which_key", "lazy", "mason", "trouble", "noice", "notify", "ibl", "mini", "snacks", "flash", "leap", "render_markdown", "bufferline" }
function M.get(c, o)
  local h = {}
  for _, name in ipairs(names) do
    if o.integrations[name] then
      h = vim.tbl_extend("force", h, require("paper-platinum.integrations." .. name)(c, o))
    end
  end
  return h
end
return M
