extends CharacterBody2D
class_name Item

var mode = MODE.GROUND_ITEM
@export var rotatable = true
@export var offset: float = 500
@export var item_name: String = "default_item"
@onready var item_sprite = $ItemSprite

@export var amount_in_stack: int = 1
@export var stackable = false

@onready var item_texture: Texture2D # = preload("res://icon.svg")

enum MODE {
	GROUND_ITEM,
	INVENTORY_ITEM,
	ACTIVE_ITEM
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if item_sprite.texture and !item_texture:
		item_texture = item_sprite.texture
		print("ALERT: you haven't properly defined a texture for item " + item_name + "!!!")
	else:
		item_sprite.texture = item_texture
	rotation = 0

func change_mode(newMode: MODE):
	mode = newMode
	
	if newMode == MODE.ACTIVE_ITEM:
		self.visible = true
		item_sprite.offset = Vector2(offset, 0)
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
	if (mode == MODE.ACTIVE_ITEM):
		if rotatable:
			look_at(get_global_mouse_position())
