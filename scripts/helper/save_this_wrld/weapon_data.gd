extends ItemData
class_name WeaponData

@export var weapon_scene_path: String

@export var damage: float = 10.0 # in hp units
@export var attack_speed: float = 1.0 # doesn't actually matter? //= animation_player.get_animation("attack").get_length() # in seconds/attack
@export var knockback_magnitude: float = 300.0 # magnitude of knockback 
@export var elemental_damage_type = Bullet.BULLET_EFFECT.NORMAL
@export var elemental_damage: float = 0.0
@export var elemental_damage_duration: float = 1.0 # in seconds
