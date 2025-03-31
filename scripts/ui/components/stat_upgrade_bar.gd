extends PanelContainer
class_name StatUpgradeBar

enum STAT_TYPE {
	DAMAGE,
	ATTACK_SPEED,
	KNOCKBACK_MAGNITUDE,
	ELEMENTAL_DAMAGE_FIRE,
	ELEMENTAL_DAMAGE_DURATION_FIRE
} #maybe use this later idk

#@export var stat_type: STAT_TYPE
@export var stat_type: String
@export var base_value: float
@export var current_value: float
@export var potential_value: float

@export var current_xp: float
@export var added_xp: float

@onready var damage_texture = preload("res://assets/sprites/ui/upgrade_icons/damage.png")
@onready var attack_speed_texture = preload("res://assets/sprites/ui/upgrade_icons/attack_speed.png")
@onready var knockback_texture = preload("res://assets/sprites/ui/upgrade_icons/knockback.png")

@onready var icon = $Container/StatIcon
@onready var current_label = $Container/InfoContainer/Stats/CurrentStat
@onready var potential_label = $Container/InfoContainer/Stats/PotentialStat
@onready var xp_progress = $Container/InfoContainer/XPBar

func _ready():
	#current_label.text = str(current_value)
	match stat_type:
		"damage":
			icon.texture = damage_texture
		"attack_speed":
			icon.texture = attack_speed_texture
		"knockback_magnitude":
			icon.texture = knockback_texture
	
	current_value = base_value * XPModifier.get_scalar(stat_type, current_xp)
	potential_value = (base_value * XPModifier.get_scalar(stat_type, current_xp + added_xp)) - current_value
	
	
	
	if added_xp:
		potential_label.text = "+(" + str(potential_value) +")"
	else:
		potential_label.text = ""
	
	current_label.text = str(current_value)
	xp_progress.value = current_xp
	xp_progress.max_value = XPModifier.get_xp_to_next_level(stat_type+"_xp", current_xp) + current_xp
	xp_progress.min_value = pow(XPModifier.get_level(stat_type, current_xp), 2) * 10 # bloated ahh logic


#$ContentContainer/InformationContainer/DamageLabel.text = str(XPModifier.get_level("damage", selected_weapon.data.xp["damage_xp"])) + " " + str(selected_weapon.data.xp["damage_xp"])
#$ContentContainer/InformationContainer/DamageProgress.value = selected_weapon.data.xp["damage_xp"]
#$ContentContainer/InformationContainer/DamageProgress.max_value = XPModifier.get_xp_to_next_level("damage_xp", selected_weapon.data.xp["damage_xp"]) + selected_weapon.data.xp["damage_xp"]
#$ContentContainer/InformationContainer/DamageProgress.min_value = pow(XPModifier.get_level("damage", selected_weapon.data.xp["damage_xp"]), 2) * 10
