extends WeaponData
class_name RangedWeaponData

@export var bullet_scene_path: String
@export var projectile_count: int
@export var bullet_scale: float = 1.0
@export var pierce: int = 1
@export var explosion_scale: float = 1.0

@export var xp: Dictionary = {
	"damage_xp": 0,
	"attack_speed_xp": 0,
	"knockback_magnitude_xp": 0,
	"elemental_damage_xp": 0,
	"elemental_damage_duration_xp": 0,
	
	# ranged weapon specific data
	"projectile_count_xp": 0,
	"bullet_size_xp": 0,
	"pierce_xp": 0,
	"explosive_power_xp": 0,
	
}
