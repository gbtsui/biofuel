extends Weapon
class_name MeleeWeapon

@onready var hurtbox = $Pivot/PointyThing/Hurtbox
@onready var animation_player = $AnimationPlayer

@export var damage: float = 10.0 # in hp units
@onready var attack_speed: float = animation_player.get_animation("attack").get_length() # in seconds/attack
@export var knockback_magnitude: float = 300.0 # magnitude of knockback 
@export var elemental_damage_type = Bullet.BULLET_EFFECT.NORMAL
@export var elemental_damage: float = 0.0
@export var elemental_damage_duration: float = 1.0 # in seconds

@export var xp: Dictionary = {
	"damage_xp": 0,
	"attack_speed_xp": 0,
	"knockback_magnitude_xp": 0,
	"elemental_damage_xp": 0,
	"elemental_damage_duration_xp": 0,
}

func add_xp(added_xp: Dictionary, multiplier: int):
	for entry in added_xp:
		xp[entry] += added_xp[entry] * multiplier

func _ready():
	$Pivot/PointyThing/Hurtbox/HurtboxCollision.disabled = true
	
	item_texture_path = item_texture_path if item_texture_path else "res://assets/sprites/weapons/test/axe.png"
	super()
	#$ItemSprite.texture = item_texture

func _process(delta) -> void:
	super(delta)
	if mode == MODE.ACTIVE_ITEM:
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
		$Pivot.position = Vector2(self.offset, 0)
		$Pivot/PointyThing.position = Vector2(self.offset, 0)
	elif newMode == MODE.GROUND_ITEM:
		item_sprite.visible = true
		$Pivot/PointyThing/WeaponSprite.visible = false
		$Pivot.position = Vector2(0, 0)
		$Pivot/PointyThing.position = Vector2(0, 0)
	elif newMode == MODE.INVENTORY_ITEM:
		item_sprite.visible = false
		$Pivot/PointyThing/WeaponSprite.visible = false


func attack() -> void:
	reset_cooldown_timer(attack_speed / XPModifier.get_scalar("attack_speed", xp.attack_speed_xp))
	animation_player.play("attack", -1, attack_speed / animation_player.get_animation("attack").get_length() * XPModifier.get_scalar("attack_speed", xp.attack_speed_xp))

func _on_hurtbox_detected(body: Node2D) -> void:
	if body is Enemy:
		body.damage(damage * XPModifier.get_scalar("damage", xp.damage_xp))
		body.set_effect(elemental_damage_type, elemental_damage_duration * XPModifier.get_scalar("elemental_damage_duration", xp.elemental_damage_duration_xp), elemental_damage * XPModifier.get_scalar("elemental_damage", xp.elemental_damage_xp))
		body.knockback((body.global_position - self.global_position).normalized(), (knockback_magnitude * XPModifier.get_scalar("knockback_magnitude", xp.knockback_magnitude_xp)))
