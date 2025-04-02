extends HBoxContainer
class_name StatDisplay

@onready var damage_texture = preload("res://assets/sprites/ui/upgrade_icons/damage.png")
@onready var attack_speed_texture = preload("res://assets/sprites/ui/upgrade_icons/attack_speed.png")
@onready var knockback_texture = preload("res://assets/sprites/ui/upgrade_icons/knockback.png")

@export var stat_type: String
@export var value: float
@onready var icon: TextureRect = $TextureRect

func _ready():
	match stat_type:
		"damage":
			icon.texture = damage_texture
		"attack_speed":
			icon.texture = attack_speed_texture
		"knockback_magnitude":
			icon.texture = knockback_texture
	
	$Label.text = str(value)
