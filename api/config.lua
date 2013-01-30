function load(name)
  local cfgData = {}
  local file = io.open(name, "r")
  for line in file:lines() do
    local k,v = line:match("(%w+):(%w+)")
    cfgData[k] = v
  end
  file:close()
  return cfgData
end

function write(name, data)
  local file = io.open(name, "w")
  for k,v in pairs(data) do
    file:write(k..":"..v.."\n")
  end
  file:close()
end
