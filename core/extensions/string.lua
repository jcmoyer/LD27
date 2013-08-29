local extensions = {}

local concat = table.concat

function extensions.join(delim, xs)
  local whole = {}
  for i = 1, #xs do
    whole[#whole + 1] = xs[i]
    if i + 1 <= #xs then
      whole[#whole + 1] = delim
    end
  end
  return concat(whole)
end

function extensions.split(s, p, noempty)
  if s == '' then
    return {}
  end
  
  noempty = noempty or false
  
  local t    = {}
  local base = 1
  local a, b = s:find(p, 1)
  
  while a do
    local part = s:sub(base, a - 1)
    if #part > 0 or (#part == 0 and not noempty) then
      t[#t + 1] = part
    end
    base      = b + 1
    a, b      = s:find(p, base)
  end
  
  if base <= #s then
    t[#t + 1] = s:sub(base)
  elseif base > #s and not noempty then
    t[#t + 1] = ''
  end
  
  return t
end

return extensions