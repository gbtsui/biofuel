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
		_save = SaveGame.load_default_save() as SaveGame
		#_save = SaveGame.new()
		#_save.player_stats = PlayerStats.new()
		#_save.world_state = WorldData.new()
		#_save.write_savegame()
	
	player.global_position = _save.player_stats.global_position
	player.stats = _save.player_stats
	
	var crafting_material_scene = preload("res://scenes/items/crafting_material/crafting_material.tscn")
	var seed_scene = preload("res://scenes/items/seeds/seed.tscn")
	var item_scene = preload("res://scenes/items/item.tscn")
	
	
	for item in _save.inventory:
		var item_instance
		if item is WeaponData:
			item_instance = load(item.weapon_scene_path).instantiate()
		elif item.item_type == item.ITEM_TYPE.CRAFTING_MATERIAL:
			item_instance = crafting_material_scene.instantiate()
		elif item.item_type == ItemData.ITEM_TYPE.SEED:
			item_instance = seed_scene.instantiate()
		else:
			item_instance = item_scene.instantiate()
		
		item_instance.data = item
		item_instance.global_position = item.item_global_position
		add_child(item_instance)
		player.inventory.pickup_item(item_instance)
	
	var tilled_dirt_scene = preload("res://scenes/home/tilled_dirt.tscn")
	for plot in _save.plots:
		var tilled_dirt_instance = tilled_dirt_scene.instantiate()
		tilled_dirt_instance.data = plot
		tilled_dirt_instance.global_position = plot.plot_global_position
		self.add_child(tilled_dirt_instance)
		if plot.current_crop:
			$TargetController.add_target(tilled_dirt_instance)

	for item_data in _save.items:
		var item_instance
		
		if item_data.item_type == ItemData.ITEM_TYPE.CRAFTING_MATERIAL:
			item_instance = crafting_material_scene.instantiate()
		elif item_data.item_type == ItemData.ITEM_TYPE.SEED:
			item_instance = seed_scene.instantiate()
		elif item_data is WeaponData:
			item_instance = load(item_data.weapon_scene_path).instantiate() # TODO: gotta switch this up later to actual scenes btw
		else:
			item_instance = item_scene.instantiate()
		
		item_instance.data = item_data
		item_instance.global_position = item_data.item_global_position
		self.add_child(item_instance)
	
	for enemy_data in _save.enemies:
		var enemy_instance = load(enemy_data.enemy_scene_path).instantiate()
		enemy_instance.data = enemy_data
		enemy_instance.global_position = enemy_data.enemy_global_position
		add_child(enemy_instance)
		$GameController.add_enemy_to_array(enemy_instance)
	
	$GameController.data = _save.world_state

func save_this_wrld():
	_save.player_stats.global_position = player.global_position
	_save.player_stats = player.stats
	var children = get_children()
	var plot_data_array: Array[TilledDirtData] = []
	var items_data_array: Array[ItemData] = []
	var inventory: Array[ItemData] = [] # finish later cyka
	var enemies: Array[EnemyData] = []
	for item in player.inventory.items:
		if item:
			inventory.append(item.data)
	
	for child in children:
		if child is TilledDirt:
			var data = child.data
			data.plot_global_position = child.global_position
			plot_data_array.append(data)
		elif child is Item:
			var data = child.data
			data.item_global_position = child.global_position
			if child is CraftingMaterial:
				data.item_type = ItemData.ITEM_TYPE.CRAFTING_MATERIAL
			elif child is Seed:
				data.item_type = ItemData.ITEM_TYPE.SEED
			items_data_array.append(data)
		elif child is Enemy:
			var data = child.data
			data.enemy_global_position = child.global_position
			enemies.append(data)
	_save.items = items_data_array
	_save.plots = plot_data_array
	_save.inventory = inventory
	_save.enemies = enemies
	_save.world_state = $GameController.data
	_save.write_savegame()
