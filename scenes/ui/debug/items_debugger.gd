extends HBoxContainer

@onready var crafting_material_scene = preload("res://scenes/items/crafting_material/crafting_material.tscn")

func _spawn_item() -> void:
	var new_text = $CraftingMaterialCreator/LineEdit.text
	var new_material_instance = CraftingMaterialDatabase.append_material_data(crafting_material_scene.instantiate(), new_text)
	if new_material_instance == null:
		$CraftingMaterialCreator/ItemName.text = "material doesn't exist!"
		return
	else:
		$CraftingMaterialCreator/ItemName.text = new_material_instance.data.item_name + " necessarily exists."
	new_material_instance.global_position = Vector2(int($CraftingMaterialCreator/HBoxContainer/xInput.text), int($CraftingMaterialCreator/HBoxContainer/yInput.text))
	
	get_tree().get_root().get_node("World").add_child(new_material_instance)
