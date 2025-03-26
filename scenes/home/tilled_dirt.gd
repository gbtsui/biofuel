extends Area2D
class_name TilledDirt

@onready var planting_timer = $PlantingTimer
@export var harvestable: bool = false
@export var current_crop: String = ""

@onready var crop_scene = preload("res://scenes/items/crops/crop.tscn")
@onready var target_controller = get_tree().get_root().get_node("World/TargetController")
#@export var current_plant: Plant = null
#@export var current_crop: Crop = null

@export var yield_min: int
@export var yield_max: int

@export var plot_hp: float = 100.0
@export var crop_hp: float

func harvest() -> void:
	if harvestable:
		var yield_num = randi_range(yield_min, yield_max)
		for crop in yield_num:
			#var crop_instance = CraftingMaterialDatabase.get_crafting_material(current_crop)
			var crop_instance = CraftingMaterialDatabase.append_material_data(crop_scene.instantiate(), current_crop)
			
			if (!crop_instance):
				print(current_crop + " doesn't exist! cannot be harvested")
				break
			
			crop_instance.global_position = self.global_position + Vector2(randi_range(-30, 30), randi_range(-30, 30)) #replace with an actual animation/tween later
			crop_instance.visible = true
			get_tree().get_root().add_child(crop_instance)
		harvestable = false
		$Label.text = ""
		#current_crop = null
		current_crop = ""
		target_controller.remove_target(self)


func _on_body_entered(body: Node2D) -> void:
	if body.get_parent() is Seed and !current_crop:
		$CollisionShape2D.disabled = true
		var current_seed: Seed = body.get_parent()
		current_crop = current_seed.crop_name
		#current_crop = CraftingMaterialDatabase.get_crafting_material(current_seed.crop_name)#load("res://scenes/items/crops/crop.tscn").instantiate()
		#current_crop.item_name = current_seed.crop_name
		# set properties based on seed data here
		yield_min = current_seed.yield_min
		yield_max = current_seed.yield_max
		#crop_scene = current_seed.crop_scene
		crop_hp = current_seed.seed_hp
		$PlantingTimer.wait_time = current_seed.growth_time
		
		current_seed.queue_free()
		$PlantingTimer.start()
		target_controller.add_target(self)

func _on_planting_timer_timeout() -> void:
	$Label.text = "harvestable btw"
	harvestable = true
