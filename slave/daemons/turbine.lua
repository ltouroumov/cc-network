local cfg = config.load("mon.cfg")
local gate = peripheral.wrap("bottom")

local data, msg
while true do
  data = gate.get()
  msg = {
    from = os.getComputerLabel(),
    status = not data["Needs Maintenance"]
  }
  
  rednet.send(tonumber(cfg["master"]), lson.encode(msg), true)
  os.sleep(1)
end
