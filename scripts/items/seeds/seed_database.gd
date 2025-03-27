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

const SEEDS := {
	"potato": {
		"crop_name":"potato",
		"crop_texture":"res://assets/sprites/plants/potato.png",
		"growth_time":5,
		"yield_min":4,
		"yield_max":7
	},
	"carrot": {
		"crop_name":"carrot",
		"crop_texture":"res://assets/sprites/plants/carrot.png",
		"growth_time": 5,
		"yield_min": 4,
		"yield_max": 7
	},
	"beetroot": {
		"crop_name":"beetroot",
		"crop_texture":"res://assets/sprites/unsorted/beetroot.png"
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
	
	seed.item_name = seed_data.crop_name + "_seed"
	seed.crop_name = seed_data.crop_name
	seed.growth_time = seed_data.growth_time
	seed.yield_min = seed_data.yield_min
	seed.yield_max = seed_data.yield_max
	
	seed.seed_hp = seed_data.seed_hp if seed_data.has("seed_hp") else 50.0
	
	seed.item_texture_path = seed_data.packet_texture if seed_data.has("packet_texture") else "res://assets/sprites/unsorted/seed_packet.png"
	seed.seed_texture = load(seed_data.seed_texture) if seed_data.has("seed_texture") else load("res://assets/sprites/unsorted/seed.png")
	
	return seed
