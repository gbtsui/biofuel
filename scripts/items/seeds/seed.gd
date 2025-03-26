extends Item
class_name Seed

@export var seed_mode: SEED_MODE = SEED_MODE.ITEM
@onready var seed_scene = preload("res://scenes/items/seeds/seed.tscn")
@export var deceleration: float = 300
@export var initial_speed: float = 500

@export var growth_time: float = 5.0
@export var crop_name: String = "default"
#@export var crop_scene = preload("res://scenes/items/crops/crop.tscn")
@export var yield_min: int = 3
@export var yield_max: int = 7

@export var seed_texture: Texture2D

@export var seed_hp: float = 50.0



@onready var player = get_tree().get_root().get_node("World/Player")

enum SEED_MODE {
	ITEM,
	FIRING,
	PLANTED
}

func _ready():
	super()
	$SeedSprite.texture = seed_texture
	if seed_mode == SEED_MODE.FIRING:
		$SeedSprite.visible = true
		$ItemSprite.visible = false
	else:
		$SeedSprite.visible = false

func fire():
	var seed_instance = SeedDatabase.append_seed_data(seed_scene.instantiate(), self.crop_name)
	seed_instance.seed_mode = SEED_MODE.FIRING
	seed_instance.global_transform = self.global_transform
	seed_instance.velocity = Vector2(cos(seed_instance.global_rotation), sin(seed_instance.global_rotation)) * initial_speed
	get_tree().get_root().add_child(seed_instance)
	seed_instance.change_mode(Item.MODE.GROUND_ITEM)
	player.inventory.subtract_item(self.item_name, 1)
	$SeedSprite.visible = true
	$ItemSprite.visible = false

func _process(delta: float) -> void:
	super(delta)
	
	if seed_mode == SEED_MODE.ITEM and mode == MODE.ACTIVE_ITEM:
		if Input.is_action_just_pressed("mouseRight"):
			fire()
		$SeedSprite.visible = false
		$ItemSprite.visible = true
	
	if seed_mode == SEED_MODE.ITEM:
		$SeedDetector/SeedHitbox.disabled = true
	
	if seed_mode == SEED_MODE.PLANTED:
		$ItemSprite.visible = false
		$SeedDetector/SeedHitbox.disabled = true
	
	if seed_mode == SEED_MODE.FIRING:
		var direction = velocity
		$SeedDetector/SeedHitbox.disabled = false
		velocity = velocity.move_toward(Vector2.ZERO, delta * deceleration)
		move_and_slide()
		if velocity == Vector2.ZERO:
			seed_mode = SEED_MODE.ITEM
			change_mode(Item.MODE.GROUND_ITEM)
		$SeedSprite.visible = true
		$ItemSprite.visible = false
	else:
		$SeedDetector/SeedHitbox.disabled = true
