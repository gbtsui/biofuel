extends Resource
class_name ItemData

@export var mode = Item.MODE.GROUND_ITEM
@export var rotatable = true
@export var offset: float = 200
@export var item_name: String = "default_item"
@export var amount_in_stack: int = 1
@export var stackable = false
@export var item_texture_path: String = ""

@export var xp_upgrade_values := {}

@export var item_global_position: Vector2
@export var item_type = ITEM_TYPE.ITEM
enum ITEM_TYPE {
	ITEM,
	CRAFTING_MATERIAL,
	SEED
}
