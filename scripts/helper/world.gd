extends Node2D

@onready var game_controller = $GameController
@onready var target_controller = $TargetController

@onready var player = $Player

var _save: SaveGame

func _ready():
	_create_or_load_save()
	# do other stuff here idk

func _process(delta):
	var chance = round(randf() * 100)
	if chance > 99:
		save_this_wrld()

func _create_or_load_save():
	if SaveGame.save_exists():
		_save = SaveGame.load_savegame() as SaveGame
	else:
		print("save doesn't exist!")
		_save = SaveGame.new()
		_save.player_stats = PlayerStats.new()
		_save.write_savegame()
	
	player.global_position = _save.player_stats.global_position
	player.stats = _save.player_stats

func save_this_wrld():
	_save.player_stats.global_position = player.global_position
	_save.write_savegame()
