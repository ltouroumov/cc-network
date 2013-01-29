os.loadAPI("/monitor/config")
os.loadAPI("/monitor/lson")
local cfg

function setup()
  local masterId, mode, side
  print("Monitor software setup")
  print("Master ID:")
  masterId = read()
  print("Daemon mode:")
  mode = read()
  print("Rednet Side:")
  side = read()
    
  local cfg = {
    ["master"] = masterId,
    ["mode"] = mode,
    ["side"] = side
  }
  
  config.write("mon.cfg", cfg)
  return cfg
end

function launchDaemon()
  rednet.open(cfg["side"])
  shell.run("monitor/"..cfg["mode"])
end

if not fs.exists("mon.cfg") then
  cfg = setup()
else
  cfg = config.load("mon.cfg")
end

print("Starting "..cfg["mode"])
print("on "..os.getComputerID())
launchDaemon()
