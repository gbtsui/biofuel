extends Resource
class_name PlantDatabase

const PLANTS := {
	"carrot": {
		"name": "carrot",
		"growth_time": 12,
		"sprite_path": "res://assets/sprites/plants/carrot.png"
	},
	"potato": {
		"name": "potato",
		"growth_time": 15,
		"sprite_path": "res://assets/sprites/plants/potato.png"
	}
}

static func create_plant(plant_type: String) -> Plant:
	var plant_data = PLANTS.get(plant_type)
	if plant_data:
		var plant = Plant.new()
		plant.plant_name = plant_data.name
		plant.growth_time = plant_data.growth_time
		plant.plant_sprite = load(plant_data.sprite_path) #this is broken, fix it later
		return plant
	return null

static func get_all_plants() -> Array:
	var plants: Array[Plant] = []
	for plant_type in PLANTS.keys():
		plants.append(create_plant(plant_type))
	return plants
