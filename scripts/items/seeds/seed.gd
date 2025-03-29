extends Item
class_name Seed

@onready var seed_scene = preload("res://scenes/items/seeds/seed.tscn")
@onready var player = get_tree().get_root().get_node("World/Player")

enum SEED_MODE {
	ITEM,
	FIRING,
	PLANTED
}

func _ready():
	super()
	$SeedSprite.texture = load(data.seed_texture_path)
	if data.seed_mode == SEED_MODE.FIRING:
		$SeedSprite.visible = true
		$ItemSprite.visible = false
	else:
		$SeedSprite.visible = false

func fire():
	var seed_instance = SeedDatabase.append_seed_data(seed_scene.instantiate(), self.data.crop_name)
	seed_instance.data.seed_mode = SEED_MODE.FIRING
	seed_instance.global_transform = self.global_transform
	seed_instance.velocity = Vector2(cos(seed_instance.global_rotation), sin(seed_instance.global_rotation)) * data.initial_speed
	get_tree().get_root().get_node("World").add_child(seed_instance)
	seed_instance.change_mode(Item.MODE.GROUND_ITEM)
	player.inventory.subtract_item(self.data.item_name, 1)
	$SeedSprite.visible = true
	$ItemSprite.visible = false

func _process(delta: float) -> void:
	super(delta)
	
	if data.seed_mode == SEED_MODE.ITEM and data.mode == MODE.ACTIVE_ITEM:
		if Input.is_action_just_pressed("mouseRight"):
			fire()
		$SeedSprite.visible = false
		$ItemSprite.visible = true
	
	if data.seed_mode == SEED_MODE.ITEM:
		$SeedDetector/SeedHitbox.disabled = true
	
	if data.seed_mode == SEED_MODE.PLANTED:
		$ItemSprite.visible = false
		$SeedDetector/SeedHitbox.disabled = true
	
	if data.seed_mode == SEED_MODE.FIRING:
		var direction = velocity
		$SeedDetector/SeedHitbox.disabled = false
		velocity = velocity.move_toward(Vector2.ZERO, delta * data.deceleration)
		move_and_slide()
		if velocity == Vector2.ZERO:
			data.seed_mode = SEED_MODE.ITEM
			change_mode(Item.MODE.GROUND_ITEM)
		$SeedSprite.visible = true
		$ItemSprite.visible = false
	else:
		$SeedDetector/SeedHitbox.disabled = true
