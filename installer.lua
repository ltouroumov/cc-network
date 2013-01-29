if fs.exists("/monitor") then
  print("Already installed, updating")
  fs.delete("/monitor")
  fs.delete("/startup")
end

fs.copy("/disk/monitor",    "/monitor")
fs.copy("/disk/bootloader", "/startup")

print("Rename Computer ?")
local evt, chr = os.pullEvent("char")
if chr == "y" then
  print("Name the computer:")
  os.setComputerLabel(read())
end

print("Running the monitor")
shell.run("/monitor/main")
