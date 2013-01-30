local fast = false
local mode = { "menu" }

print("Site Monitoring Software Updater")

function main(mode, fast)
	-- when in fast mode, dont ask questions -> run the mode directly
	if not fast then
		if fs.exists("/slave") then
		  print("Slave already installed, update selected")

		  mode = { "slave", "update" }

		  print("Remove existing code")
		  fs.delete("/slave")
		  fs.delete("/startup")
		end

		fs.copy("/disk/slave", "/slave")
		fs.move("/slave/boot", "/startup")

		print("Rename Computer ?")
		local evt, chr = os.pullEvent("char")
		if chr == "y" then
		  print("Name the computer:")
		  os.setComputerLabel(read())
		end

		print("Running the monitor")
		shell.run("/monitor/main")
end

function loadInstaller(mode)
	
end

local installers = {
	
	slave = 

}

main(mode, fast)