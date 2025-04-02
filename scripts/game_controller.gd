extends Node
class_name GameController

@onready var player = get_tree().get_root().get_node("World/Player")
@onready var death_ui = preload("res://scenes/ui/new_death_ui.tscn")

@export var data: WorldData
@onready var world_modulate: CanvasModulate = get_tree().get_root().get_node("World/CanvasModulate")

@export var spawn_locations: Array[Vector2] = []
@export var current_enemies: Array[Enemy] = []

var spawn_cooldown: float = 0.0
var spawn_cooldown_min: float = 0.5
var spawn_cooldown_max: float = 1.0

func spawn_wave(day_number: int):
	var wave_data = WaveDatabase.get_wave(day_number)
	for enemy in wave_data.keys():
		var enemy_data = EnemyDatabase.get_enemy_data(enemy)
		for i in range(wave_data[enemy]):
			data.spawn_queue.append(enemy_data)

func spawn_random(day_number: int):
	var data = WaveDatabase.get_between_waves(day_number)
	for enemy in data.keys():
		var enemy_data = EnemyDatabase.get_enemy_data(enemy)
		for i in range(data[enemy]):
			data.spawn_queue.append(enemy_data)

func spawn_enemy(enemy_data: EnemyData, pos: Vector2):
	var enemy: Enemy = enemy_data.enemy_scene.instantiate()
	enemy.global_position = pos
	enemy.data = enemy_data
	enemy.data.hp = enemy.data.max_hp
	get_tree().get_root().get_node("World").add_child(enemy)
	add_enemy_to_array(enemy)

func add_enemy_to_array(enemy: Enemy):
	current_enemies.append(enemy)

func remove_enemy(enemy):
	var index = current_enemies.find(enemy)
	if (index != -1):
		current_enemies.remove_at(index)
	
	if enemy:
		enemy.queue_free() # just for safety (might remove later)

func _process(delta: float) -> void:
	data.seconds_elapsed += delta # TEMPORARY
	var current_darkness = (sin(deg_to_rad(data.seconds_elapsed)) + 1) / 2
	world_modulate.color = Color(current_darkness, current_darkness, current_darkness)
	player.light.color = Color(1 - current_darkness, 1 - current_darkness, 1 - current_darkness)
	
	if data.seconds_elapsed/360 > data.current_day:
		spawn_wave(data.current_day)
		data.current_day += 1
	
	spawn_cooldown -= delta
	if data.spawn_queue.size() > 0 and spawn_cooldown <= 0:
		var location = spawn_locations.pick_random()
		spawn_enemy(data.spawn_queue[0], location)
		data.spawn_queue.remove_at(0)
		spawn_cooldown = randf_range(spawn_cooldown_min, spawn_cooldown_max)
	
	if randf() < 0.001:
		spawn_random(data.current_day)

func _ready():
	player.player_died.connect(end_game)
	
	var children = get_tree().get_root().get_node("World").get_children()
	
	for child in children:
		if child is SpawnPoint:
			spawn_locations.append(child.global_position)
	
	print(spawn_locations)

func quit_game():
	#get_tree().quit()
	get_tree().change_scene_to_file("res://scenes/ui/title_screen.tscn")
	# add more stuff later here ig

func end_game():
	var death_ui_instance = death_ui.instantiate()
	player.get_node("UiLayer").add_child(death_ui_instance)
	SaveGame.delete_save("placeholder path")
	get_tree().paused = true
