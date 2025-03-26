extends Node

@onready var player = get_tree().get_root().get_node("World/Player")
@onready var death_ui = preload("res://scenes/ui/death_ui.tscn")
@onready var seed = preload("res://scenes/items/seeds/seed.tscn")

func _process(delta: float) -> void:
	#if Input.is_action_just_pressed("escape"):
	#	get_tree().quit()
	#if Input.is_action_just_pressed("pickUp"):
	#	var seed = SeedDatabase.append_seed_data(seed.instantiate(), "potato")
	#	seed.global_position = Vector2(randf() - 0.5, randf() - 0.5) * 25
	#	get_tree().get_root().add_child(seed)
	pass

func _ready():
	player.player_died.connect(end_game)

func quit_game():
	get_tree().quit()
	# add more stuff later here ig

func end_game():
	var death_ui_instance = death_ui.instantiate()
	player.get_node("UiLayer").add_child(death_ui_instance)
	while true:
		Engine.time_scale = move_toward(Engine.time_scale, 0, 0.05)
		await get_tree().create_timer(0.1).timeout
