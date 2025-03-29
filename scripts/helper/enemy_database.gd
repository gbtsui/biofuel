extends Resource
class_name EnemyDatabase

#DATABASE DATABASE
#JUST LIVING IN THE DATABASE WOAH OH
#THE WALL OF PURE FICTION'S CRACKING IN MY HEAD
#AND THE ADDICTION OF MY WORLD STILL SPREADS
#IN THE DATABASE DATABASE
#I'M STRUGGLING IN THE DATABASE WOAH OH
#IT DOESN'T EVEN MATTER IF THERE IS NO HOPE
#AS THE MADNESS OF THE SYSTEM GROWS

enum ENEMY_TYPES {
	NORMAL,
	BOSS
}

const ENEMIES: Dictionary = {
	"blank_aphid": {
		"enemy_scene_path":"res://scenes/enemies/blank_aphid.tscn",
		"enemy_scene":preload("res://scenes/enemies/blank_aphid.tscn"),
		"enemy_type": ENEMY_TYPES.NORMAL,
		
		"max_hp":50,
		"baseSpeed": 200,
		
		"weight":1,
		
		"player_target_weight":0.5,
		"plot_target_weight": 1,
		
		"attack_damage":5.0,
		"plot_attack_damage": 10.0
	}
}

static func get_enemy_data(name: String) -> EnemyData:
	var enemy_data = ENEMIES.get(name)
	print(enemy_data)
	var data: EnemyData
	
	if enemy_data.enemy_type == ENEMY_TYPES.NORMAL:
		data = EnemyData.new()
	

	for key in enemy_data.keys():
		data[key] = enemy_data[key]
	print(data)
	return data
