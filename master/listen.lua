os.loadAPI("/api/lson")
os.loadAPI("/api/gui")
os.loadAPI("/api/config")

rednet.open("bottom")

local view = term
local data = {}

function bindValue(comp, prop, def)
  return function()
    local cmp = data[comp]
    if cmp == nil then
      return def
    end
    
    local val = cmp[prop]
    if val == nil then
      return def
    end
    return val
  end
end

local helpers = {
  showBool = function(val)
    if val then
      return "YES"
    else
      return "NO "
    end
  end,
  boolColor = function(val)
    if val then
      return colors.green
    else
      return colors.red
    end
  end
}

-- 34: EU Boiler
-- 37: Turbine 1
local binds = {
  b1_fuel = bindValue(34, "fuel", false),
  b1_heat = bindValue(34, "hot", false),
  t1 = bindValue(37, "status", false),
  t2 = bindValue(39, "status", false),
  t3 = bindValue(41, "status", false),
  t4 = bindValue(40, "status", false),
  b2_fuel = bindValue(44, "fuel", false),
  b2_heat = bindValue(44, "hot", false),
  t5 = bindValue(45, "status", false),
  t6 = bindValue(46, "status", false)
}

local disp = {
  { type = "label",
    value = gui.centerText(view, "[ Energy Generators ]"),
    color = colors.orange,
    pos = { 1, 1 } },
    
  { type = "label",
    value = "Boiler (EU)",
    color = colors.orange,
    pos = { 2, 3 } },
    
  { type = "info", bind = binds.b1_fuel,
    label = "Fuel",
    func = helpers.showBool,
    func_color = helpers.boolColor,
    pos = { 2, 4 } },
  { type = "info", bind = binds.b1_heat,
    label = "Heat",
    func = helpers.showBool,
    func_color = helpers.boolColor,
    pos = { 2, 5 } },
    
  { type = "info", bind = binds.t1,
    label = "Turbine 1",
    func = helpers.showBool,
    func_color = helpers.boolColor,
    pos = { 12, 4 } },
  { type = "info", bind = binds.t2,
    label = "Turbine 2",
    func = helpers.showBool,
    func_color = helpers.boolColor,
    pos = { 12, 5 } },
  { type = "info", bind = binds.t3,
    label = "Turbine 3",
    func = helpers.showBool,
    func_color = helpers.boolColor,
    pos = { 12, 6 } },
  { type = "info", bind = binds.t4,
    label = "Turbine 4",
    func = helpers.showBool,
    func_color = helpers.boolColor,
    pos = { 12, 7 } },
  
  { type = "label",
    value = "Boiler (Scrap)",
    color = colors.orange,
    pos = { 2, 9 } },
  { type = "info", bind = binds.b2_fuel,
    label = "Fuel",
    func = helpers.showBool,
    func_color = helpers.boolColor,
    pos = { 2, 10 } },
  { type = "info", bind = binds.b2_heat,
    label = "Heat",
    func = helpers.showBool,
    func_color = helpers.boolColor,
    pos = { 2, 11 } },
  { type = "info", bind = binds.t5,
    label = "Turbine 1",
    func = helpers.showBool,
    func_color = helpers.boolColor,
    pos = { 12, 10 } },
  { type = "info", bind = binds.t6,
    label = "Turbine 2",
    func = helpers.showBool,
    func_color = helpers.boolColor,
    pos = { 12, 11 } }
}

function updateData()
  while true do
    local _, sender, msg, dist = os.pullEvent("rednet_message")
    data[sender] = lson.decode(msg)
  end
end

function filterControls(type)
  local f = {}
  for _, c in pairs(disp) do
    if c.type == type then
      table.insert(f, c)
    end
  end
  
  return f
end

function get(ctrl, prop, def)
  local val = ctrl[prop]
  if val == nil then
    val = def
  end
  
  return val
end

function coords(pos)
  return pos[1], pos[2]
end

function setupScreen()
  local labels = filterControls("label")
  for _, label in pairs(labels) do
    x, y = coords(get(label, "pos", {0,0}))
    col  = get(label, "color", colors.white)
    val  = get(label, "value", "Null")
    
    gui.writeAt(view, x, y, val, col)
  end
end

function renderControls()
  local infos = filterControls("info")
  for _, info in pairs(infos) do
    x, y = coords(get(info, "pos", {0,0}))
    bind = get(info, "bind")
    lbl  = get(info, "label", "Null")
    lbll = string.len(lbl)
    txt  = get(info, "func")
    
    c1 = get(info, "label_color", colors.white)
    c2 = get(info, "func_color")
    
    if c2 == nil then
      print(lbl.." nil color")
    end
    
    val = bind()
    txt = txt(val)
    c2  = c2(val)
    
    gui.writeAt(view, x, y, lbl, c1)
    gui.writeAt(view, x + lbll + 1, y, txt, c2)
  end
end

function mainScreen()
  setupScreen()
  renderControls()
end

function dataList()
  gui.writeAt(view, 1, 1, "Data List")
  
  h = 3
  for c, d in pairs(data) do
    gui.writeAt(view, 1, h, c..":"..lson.encode(d))
    h=h+1
  end
end

local controller = mainScreen

function displayData()
  view.setBackgroundColor(colors.blue)
  rednet.broadcast("MASTEROK")
  while true do
    view.clear()
    controller()
    
    os.sleep(0.5)
  end
end

function readKeys()
  local w, h = view.getSize()
  local active = true
  while active do
    local evt, chr = os.pullEvent("char")
    
    if chr == "q" then
      active = false
    elseif chr == "m" then
      controller = mainScreen
    elseif chr == "l" then
      controller = dataList
    else
      gui.writeAt(view, w, h, chr, colors.gray)
    end
  end
end

parallel.waitForAny(updateData, displayData, readKeys)
view.setTextColor(colors.white)
view.setBackgroundColor(colors.black)
view.clear()
view.setCursorPos(1, 1)
print("Exiting ...")
