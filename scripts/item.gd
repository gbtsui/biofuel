extends CharacterBody2D
class_name Item

var mode = MODE.GROUND_ITEM
const rotatable = true
@export var offset: float = 50

@onready var item_sprite = $ItemSprite

enum MODE {
	GROUND_ITEM,
	INVENTORY_ITEM,
	ACTIVE_ITEM
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	rotation = 0

func change_mode(newMode: MODE):
	mode = newMode
	
	if newMode == MODE.ACTIVE_ITEM:
		item_sprite.offset = Vector2(0, offset)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (mode == MODE.ACTIVE_ITEM):
		if rotatable:
			look_at(get_global_mouse_position())
