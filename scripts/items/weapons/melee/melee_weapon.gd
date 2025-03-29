extends Weapon
class_name MeleeWeapon

@onready var hurtbox = $Pivot/PointyThing/Hurtbox
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func set_melee_weapon_stats():
	var new_data = MeleeWeaponData.new()
	

func add_xp(added_xp: Dictionary, multiplier: int):
	for entry in added_xp:
		data.xp[entry] += added_xp[entry] * multiplier

func _ready():
	$Pivot/PointyThing/Hurtbox/HurtboxCollision.disabled = true
	
	data.item_texture_path = data.item_texture_path if data.item_texture_path else "res://assets/sprites/weapons/test/axe.png"
	
	super()
	#$ItemSprite.texture = item_texture

func _process(delta) -> void:
	super(delta)
	if data.mode == MODE.ACTIVE_ITEM:
		if Input.is_action_just_pressed("mouseLeft") and fireable and get_parent().player_mode == Player.PLAYER_MODE.PLAYABLE:
			attack()
		
		scale = Vector2(1, 1) if get_global_mouse_position().x > global_position.x else Vector2(1, -1)
	#print(cooldown_timer)

func change_mode(newMode: Item.MODE):
	super(newMode)
	#mode = newMode
	if newMode == MODE.ACTIVE_ITEM:
		item_sprite.visible = false
		$Pivot/PointyThing/WeaponSprite.visible = true
		$Pivot.position = Vector2(self.data.offset, 0)
		$Pivot/PointyThing.position = Vector2(self.data.offset, 0)
	elif newMode == MODE.GROUND_ITEM:
		item_sprite.visible = true
		$Pivot/PointyThing/WeaponSprite.visible = false
		$Pivot.position = Vector2(0, 0)
		$Pivot/PointyThing.position = Vector2(0, 0)
	elif newMode == MODE.INVENTORY_ITEM:
		item_sprite.visible = false
		$Pivot/PointyThing/WeaponSprite.visible = false


func attack() -> void:
	reset_cooldown_timer(data.attack_speed / XPModifier.get_scalar("attack_speed", data.xp.attack_speed_xp))
	animation_player.play("attack", -1, 1 /  XPModifier.get_scalar("attack_speed", data.xp.attack_speed_xp))

func _on_hurtbox_detected(body: Node2D) -> void:
	if body is Enemy:
		body.damage(data.damage * XPModifier.get_scalar("damage", data.xp.damage_xp))
		body.set_effect(data.elemental_damage_type, data.elemental_damage_duration * XPModifier.get_scalar("elemental_damage_duration", data.xp.elemental_damage_duration_xp), data.elemental_damage * XPModifier.get_scalar("elemental_damage", data.xp.elemental_damage_xp))
		body.knockback((body.global_position - self.global_position).normalized(), (data.knockback_magnitude * XPModifier.get_scalar("knockback_magnitude", data.xp.knockback_magnitude_xp)))
