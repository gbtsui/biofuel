extends Resource
class_name SeedDatabase

# required fields:
# crop_name
# crop_texture
# growth_time
# yield_min
# yield_max

# optional fields
# seed_hp
# deceleration
# initial_speed

const seed_scene = preload("res://scenes/items/seeds/seed.tscn")

const SEEDS := {
	"potato": {
		"crop_texture":"res://assets/sprites/plants/potato.png",
		"growth_time":200,
		"yield_min":4,
		"yield_max":7
	},
	"carrot": {
		"crop_texture":"res://assets/sprites/plants/carrot.png",
		"growth_time": 200,
		"yield_min": 2,
		"yield_max": 4
	},
	"beetroot": {
		"crop_texture":"res://assets/sprites/unsorted/beetroot.png",
		"growth_time": 200,
		"yield_min": 3,
		"yield_max": 5
	},
	"leek":{
		"crop_texture":"res://assets/sprites/plants/leek.png",
		"growth_time": 200,
		"yield_min": 2,
		"yield_max": 3
	},
	"sugarcane":{
		"crop_texture":"res://assets/sprites/plants/sugarcane.png",
		"growth_time":180,
		"yield_min":2,
		"yield_max":3
	},
	"chili":{
		"crop_texture":"res://assets/sprites/plants/chili.png",
		"growth_time": 360,
		"yield_min": 4,
		"yield_max": 6
	},
	"watermelon":{
		"crop_texture":"res://assets/sprites/plants/watermelon.png",
		"growth_time": 720,
		"yield_min": 1,
		"yield_max": 2
	},
	"pumpkin":{
		"crop_texture": "res://assets/sprites/plants/pumpkin.png",
		"growth_time": 600,
		"yield_min":1,
		"yield_max":1
	},
	"default":{
		"crop_name":"default",
		"crop_texture":"res://assets/sprites/stefan_vulic.jpg",
		"growth_time": 5,
		"yield_min": 10,
		"yield_max": 12
	}
}

static func append_seed_data(seed: Seed, seed_name: String):
	var seed_data = SEEDS.get(seed_name)
	if !seed_name: 
		return null
	
	var data = SeedData.new()
	
	data.item_name = seed_name + "_seed"
	data.crop_name = seed_name
	data.growth_time = seed_data.growth_time
	data.yield_min = seed_data.yield_min
	data.yield_max = seed_data.yield_max
	
	data.seed_hp = seed_data.seed_hp if seed_data.has("seed_hp") else 50.0
	
	
	data.item_texture_path = seed_data.packet_texture if seed_data.has("packet_texture") else "res://assets/sprites/unsorted/seed_packet.png"
	data.seed_texture_path = seed_data.seed_texture if seed_data.has("seed_texture") else "res://assets/sprites/unsorted/seed.png"
	data.stackable = true
	
	seed.data = data
	
	return seed

static func get_seed(seed_name):
	return append_seed_data(seed_scene.instantiate(), seed_name)
