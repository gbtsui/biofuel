extends Resource
class_name WaveDatabase

const ENEMY_WAVE_DATA = {
	"blank_aphid": {
		"difficulty": 1,
		"wave_requirement": 1
	}
}

const DEFINED_WAVES: Dictionary = {
	0: {},
	1: {
		"blank_aphid": 5
	},
	3: {
		"blank_aphid": 10
	}
}

static func get_wave(number: int):
	var difficulty: int = 0.2 * pow(number, 2) + 2 * number # TODO: honestly idrk the ideal progression curve being fr
	
	if DEFINED_WAVES.has(number):
		return DEFINED_WAVES[number]
	else:
		var wave_data = {}
		var enemy_types = ENEMY_WAVE_DATA.keys()
		var current_difficulty: int = 0
		
		while current_difficulty < difficulty:
			var rand_enemy = enemy_types[randi() % enemy_types.size()]
			if !wave_data.has(rand_enemy):
				wave_data[rand_enemy] = 0
			if current_difficulty + ENEMY_WAVE_DATA[rand_enemy]["difficulty"] <= difficulty:
				wave_data[rand_enemy] += 1
				current_difficulty += ENEMY_WAVE_DATA[rand_enemy]["difficulty"]
		
		return wave_data
