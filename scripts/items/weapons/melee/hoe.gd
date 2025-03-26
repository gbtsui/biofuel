extends MeleeWeapon

@onready var target_marker = $Target/TargetMarker
@onready var tilled_dirt = preload("res://scenes/home/tilled_dirt.tscn") #change this later

@export var right_held_down: bool = false

var exclusion_zones: Array[ExclusionZone] = []

func _ready():
	item_name = "hoe"
	offset = 10
	item_texture = preload("res://assets/sprites/weapons/hoe.png")
	damage = 20

func till():
	animation_player.play("attack")
	await get_tree().create_timer(0.2).timeout
	var pos = target_marker.global_position
	var dirt_instance = tilled_dirt.instantiate()
	dirt_instance.position = pos
	get_tree().get_root().get_node("World").add_child(dirt_instance)
	reset_cooldown_timer(attack_speed)

func _process(delta) -> void:
	super(delta)
	
	if right_held_down:
		$Target.visible = true
		$Target.global_rotation = 0
		if exclusion_zones.size() != 0:
			$Target.modulate = Color("ff000050")
		else:
			$Target.modulate = Color("ffffff50")
	
	if mode == MODE.ACTIVE_ITEM:
		if Input.is_action_just_pressed("mouseRight") and fireable and get_parent().player_mode == Player.PLAYER_MODE.PLAYABLE:
			right_held_down = true
		elif Input.is_action_just_released("mouseRight") and fireable and exclusion_zones.size() == 0 and get_parent().player_mode == Player.PLAYER_MODE.PLAYABLE:
			till()
			right_held_down = false

func _on_exclusionzone_detected(area: Area2D) -> void:
	if area is ExclusionZone:
		exclusion_zones.append(area)
	$Label.text = str(exclusion_zones)

func _on_exclusionzone_undetected(area: Area2D) -> void:
	if area is ExclusionZone:
		exclusion_zones.remove_at(exclusion_zones.find(area))
	$Label.text = str(exclusion_zones)
