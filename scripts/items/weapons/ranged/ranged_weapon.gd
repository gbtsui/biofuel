extends Weapon
class_name RangedWeapon

@onready var animation_player = $AnimationPlayer
@onready var bullet

func _ready():
	super()
	bullet = load(data.bullet_scene_path)
	#data.item_texture_path = "res://assets/sprites/weapons/test/TEST_potato_cannon.png"
	#$ItemSprite.texture = item_texture


func _process(delta: float) -> void:
	super(delta)
	if data.mode == MODE.ACTIVE_ITEM:
		if Input.is_action_just_pressed("mouseLeft") and fireable and get_parent().player_mode == Player.PLAYER_MODE.PLAYABLE:
			attack()
		
		scale = Vector2(1, 1) if get_global_mouse_position().x > global_position.x else Vector2(1, -1)


func change_mode(newMode: Item.MODE):
	super(newMode)
	#mode = newMode
	if newMode == MODE.ACTIVE_ITEM:
		item_sprite.visible = false
		$Pivot/WeaponSprite.visible = true
		$Pivot.position = Vector2(self.data.offset, 0)
	elif newMode == MODE.GROUND_ITEM:
		item_sprite.visible = true
		$Pivot/WeaponSprite.visible = false
		$Pivot.position = Vector2(0, 0)
	elif newMode == MODE.INVENTORY_ITEM:
		item_sprite.visible = false
		$Pivot/WeaponSprite.visible = false

func attack() -> void:
	reset_cooldown_timer(data.attack_speed)
	animation_player.play("attack")
	var bullet_instance = bullet.instantiate()
	bullet_instance.global_transform = $Pivot/Marker2D.global_transform
	bullet_instance.damage = data.damage
	bullet_instance.bullet_effect = data.elemental_damage_type
	bullet_instance.bullet_effect_damage = data.elemental_damage
	bullet_instance.bullet_effect_duration = data.elemental_damage_duration
	get_tree().get_root().add_child(bullet_instance)
