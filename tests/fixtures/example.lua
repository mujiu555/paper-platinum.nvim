-- Reading is the primary activity.
local Page = {}
---@param name string
function Page.open(name)
  local width, enabled = 80, true
  return "Welcome, " .. name, width, enabled
end
print(Page.open("Platinum"))
