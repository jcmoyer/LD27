local path = {}

local function join(xs, delim)
  local whole = {}
  for i=1,#xs do
    whole[#whole + 1] = xs[i]
    if i + 1 <= #xs then
      whole[#whole + 1] = '/'
    end
  end
  return table.concat(whole)
end

-- TODO: Optimize post-LD
-- Originally taken from http://lua-users.org/wiki/SplitJoin
local function split(str, pat)
  local t = {}  -- NOTE: use {n = 0} in Lua-5.0
  local fpat = "(.-)" .. pat
  local last_end = 1
  local s, e, cap = str:find(fpat, 1)
  while s do
    if s ~= 1 or cap ~= "" then
	    table.insert(t,cap)
    end
    last_end = e+1
    s, e, cap = str:find(fpat, last_end)
  end
  if last_end <= #str then
    cap = str:sub(last_end)
    table.insert(t, cap)
  end
  return t
end

function path.resolve(filename)
  local parts = split(filename, '[\\/]+')
  local resolved = {}
  
  for i=1,#parts do
    local part = parts[i]
    if part == '..' then
      table.remove(resolved, #resolved)
    else
      resolved[#resolved + 1] = part
    end
  end
  return join(resolved, '/')
end


return path