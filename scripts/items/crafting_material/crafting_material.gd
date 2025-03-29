extends Item
class_name CraftingMaterial

func _ready():
	data.stackable = true
	data.offset = 200
	super()
