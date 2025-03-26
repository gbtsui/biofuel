extends Weapon
class_name RangedWeapon

@export var damage: float = 1.0
@onready var animation_player = $AnimationPlayer
@onready var bullet = preload("res://scenes/bullets/fireBullet.tscn")

func _ready():
	super()
	item_texture = preload("res://assets/sprites/weapons/test/TEST_potato_cannon.png")
	$ItemSprite.texture = item_texture


func _process(delta: float) -> void:
	super(delta)
	if mode == MODE.ACTIVE_ITEM:
		if Input.is_action_just_pressed("mouseLeft") and fireable and get_parent().player_mode == Player.PLAYER_MODE.PLAYABLE:
			attack()
		
		scale = Vector2(1, 1) if get_global_mouse_position().x > global_position.x else Vector2(1, -1)


func change_mode(newMode: Item.MODE):
	super(newMode)
	#mode = newMode
	if newMode == MODE.ACTIVE_ITEM:
		item_sprite.visible = false
		$Pivot/WeaponSprite.visible = true
		$Pivot.position = Vector2(self.offset, 0)
	elif newMode == MODE.GROUND_ITEM:
		item_sprite.visible = true
		$Pivot/WeaponSprite.visible = false
		$Pivot.position = Vector2(0, 0)
	elif newMode == MODE.INVENTORY_ITEM:
		item_sprite.visible = false
		$Pivot/WeaponSprite.visible = false

func attack() -> void:
	reset_cooldown_timer(1)
	animation_player.play("attack")
	var bullet_instance = bullet.instantiate()
	bullet_instance.global_transform = $Pivot/Marker2D.global_transform
	get_tree().get_root().add_child(bullet_instance)
