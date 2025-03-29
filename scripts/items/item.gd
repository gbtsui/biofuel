extends CharacterBody2D
class_name Item

@onready var item_sprite = $ItemSprite
@export var data: ItemData = null:
	set(value):
		data = value
	get: 
		return data

enum MODE {
	GROUND_ITEM,
	INVENTORY_ITEM,
	ACTIVE_ITEM
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#if item_sprite.texture and !data.item_texture_path:
	#	#item_texture = item_sprite.texture
	#	print("ALERT: you haven't properly defined a texture for item " + data.item_name + "!!!")
	#else:
	item_sprite.texture = load(data.item_texture_path)
	rotation = 0

func change_mode(newMode: MODE):
	data.mode = newMode
	
	if newMode == MODE.ACTIVE_ITEM:
		self.visible = true
		item_sprite.offset = Vector2(data.offset, 0)
		$ItemHitbox.disabled = true
	elif newMode == MODE.GROUND_ITEM:
		self.visible = true
		item_sprite.offset = Vector2.ZERO
		$ItemHitbox.disabled = false
	elif newMode == MODE.INVENTORY_ITEM:
		self.visible = false
		$ItemHitbox.disabled = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (data.mode == MODE.ACTIVE_ITEM):
		if data.rotatable:
			look_at(get_global_mouse_position())
