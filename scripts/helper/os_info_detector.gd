extends Node2D
class_name OSInfoDetector

func _ready():
	var username: String = OS.get_environment("USERNAME") if OS.has_environment("USERNAME") else OS.get_environment("USER")
	$Label.text = username
	get_process([])

func get_process(targetProcessNames: Array[String]):
	var runningProcesses := []
	var command: String
	var args: Array
	
	match OS.get_name().to_lower():
		"windows":
			command = "powershell.exe"
			args = ["/C", "Get-Process | Select-Object ProcessName, Id"]
		"linux", "bsd":
			command = "ps"
			args = ["aux"]
		"macos":
			command = "ps"
			args = ["-eo", "pid,comm,%cpu,%mem"]
	
	var output = []
	var exit_code = OS.execute(command, args, output)
	
	if exit_code == 0:
	# Parse the output based on platform
		for line in output:
			if line.strip_edges():  # Skip empty lines
				var parts = line.split(" ", false)
				
				if parts.size() >= 2:  # Ensure we have at least process name and ID
					runningProcesses.append({
						"name": " ".join(parts.slice(10)),
						"pid": int(parts[1]),
					})
	
	for process in runningProcesses:
		print(runningProcesses)
	
	for targetProcess in targetProcessNames:
		pass
	pass
