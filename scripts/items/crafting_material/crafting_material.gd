extends Item
class_name CraftingMaterial

@export var xp_upgrade_values: Dictionary = {
	
}

func _ready():
	stackable = true
	offset = 200
	super()
