extends Resource
class_name WeaponDatabase

enum WEAPON_TYPES {
	MELEE,
	RANGED,
	SPECIAL
}

#TODO: replace item_path with just item as a packedscene cuz why not lol
const WEAPONS := {
	"scythe": {
		"type": WEAPON_TYPES.MELEE,
		"item_path":"res://scenes/items/weapons/melee/scythe.tscn",
		"offset":75,
		"data":{
			"damage":5.0,
			"attack_speed":1.5,
			"knockback_magnitude":200,
			"elemental_damage":0.0,
			"elemental_damage_duration":0.0,
			"elemental_damage_type":Bullet.BULLET_EFFECT.NORMAL
		}
	},
	"hoe":{
		"type": WEAPON_TYPES.MELEE,
		"item_path": "res://scenes/items/weapons/melee/hoe.tscn",
		"offset":50,
		"data":{
			"damage":20.0,
			"attack_speed": 1.0,
			"knockback_magnitude": 150,
			"elemental_damage":0.0,
			"elemental_damage_duration":0.0,
			"elemental_damage_type":Bullet.BULLET_EFFECT.NORMAL
		}
	},
	"potato_cannon":{
		"type": WEAPON_TYPES.RANGED,
		"item_path":"res://scenes/items/weapons/ranged/potato_cannon.tscn",
		"item_texture_path":"res://assets/sprites/weapons/potato_cannon.png",
		"bullet_scene_path":"res://scenes/bullets/fireBullet.tscn",
		"offset":25,
		"data":{
			"damage":17.5,
			"attack_speed":1.5,
			"knockback_magnitude":200,
			"elemental_damage":2.5,
			"elemental_damage_duration":2.5,
			"elemental_damage_type":Bullet.BULLET_EFFECT.FIRE
		}
	},
	"leek_sabre":{
		"type": WEAPON_TYPES.MELEE,
		"item_path":"res://scenes/items/weapons/melee/leek_sabre",
		"item_texture_path":"res://assets/sprites/weapons/leek_sabre.png",
		"offset":25,
		"data":{
			"damage":25,
			"attack_speed":0.6,
			"knockback_magnitude":300,
			"elemental_damage": 0,
			"elemental_damage_duration": 0,
			"elemental_damage_type": Bullet.BULLET_EFFECT.NORMAL
		}
	}
}
# TODO: do i want an elemental damage manager?? hmmmmm it would be pretty interesting ngl and not too complex

static func load_weapon(name: String):
	var data = load_weapon(name)
	var weapon_instance = load(data.item_path).instantiate()
	
	#weapon_instance.data = data
	#print(str(data))
	return weapon_instance

static func get_weapon_data(name: String):
	var weapon_data = WEAPONS.get(name)
	
	var data: WeaponData
	if weapon_data.type == WEAPON_TYPES.MELEE:
		data = MeleeWeaponData.new()
	elif weapon_data.type == WEAPON_TYPES.RANGED:
		data = RangedWeaponData.new()
	
	data.damage = weapon_data.data.damage
	data.attack_speed = weapon_data.data.attack_speed
	data.knockback_magnitude = weapon_data.data.knockback_magnitude
	data.elemental_damage = weapon_data.data.elemental_damage
	data.elemental_damage_duration = weapon_data.data.elemental_damage_duration
	data.elemental_damage_type = weapon_data.data.elemental_damage_type
	
	data.item_texture_path = weapon_data.item_texture_path
	data.offset = weapon_data.offset
	data.weapon_scene_path = weapon_data.item_path


	if weapon_data.type == WEAPON_TYPES.RANGED:
		data.bullet_scene_path = weapon_data.bullet_scene_path
	
	data.item_name = name
	
	return data
