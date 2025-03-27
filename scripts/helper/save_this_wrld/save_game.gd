extends Resource
class_name SaveGame

const SAVE_PATH = "user://save.tres"

@export var player_stats: PlayerStats

func write_savegame() -> void:
	print("Saving game...")
	ResourceSaver.save(self, SAVE_PATH)

static func save_exists() -> bool:
	return ResourceLoader.exists(SAVE_PATH)

static func load_savegame() -> Resource:
	if not ResourceLoader.has_cached(SAVE_PATH):
		return ResourceLoader.load(SAVE_PATH, "")
	
	var file := FileAccess.open(SAVE_PATH, FileAccess.READ)
	var data = file.get_file_as_string(SAVE_PATH)
	file.close()
	
	var tmp_file_path = "user://"+random_file_path()
	while ResourceLoader.has_cached(tmp_file_path):
		tmp_file_path = "user://"+random_file_path()
	file.open(tmp_file_path, FileAccess.READ_WRITE).store_string(data)
	file.close()
	
	var save = ResourceLoader.load(tmp_file_path, "")
	save.take_over_path(SAVE_PATH)
	
	DirAccess.remove_absolute(tmp_file_path)
	return save
	
static func random_file_path():
	var word = ""
	var chars = "abcdefghijklmnopqrstuvwxyz"
	for i in range(10):
		word += chars[randi() % len(chars)]
	return word
