local cache = {}

function cache.new(factory)
  local t = {}
  
  function t.get(name)
    local existing = t[name]
    if existing ~= nil then
      return existing
    else
      existing = factory(name)
      t[name] = existing
      return existing
    end
  end

  return t
end

return cache