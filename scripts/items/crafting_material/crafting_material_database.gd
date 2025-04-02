extends Resource
class_name CraftingMaterialDatabase

const CRAFTING_MATERIALS := {
	"potato": {
		"is_crop": true,
		"xp_upgrade_values": {
			"damage_xp":1.5
		},
		"item_texture": "res://assets/sprites/plants/potato.png",
	},
	"carrot": {
		"is_crop": true,
		"xp_upgrade_values": {
			"attack_speed_xp":2
		},
		"item_texture": "res://assets/sprites/plants/carrot.png",
	},
	"beetroot": {
		"is_crop": true,
		"xp_upgrade_values": {
			"damage_xp":2
		},
		"item_texture": "res://assets/sprites/plants/beetroot.png"
	},
	"sugarcane":{
		"is_crop":true,
		"xp_upgrade_values": {
			"attack_speed_xp":1.5
		},
		"item_texture": "res://assets/sprites/plants/sugarcane.png"
	},
	"leek":{
		"is_crop": true,
		"xp_upgrade_values": {
			"knockback_magnitude_xp": 3
		},
		"item_texture": "res://assets/sprites/plants/leek.png"
	}
}


static func append_material_data(crafting_material: CraftingMaterial, material_name: String) -> CraftingMaterial:
	var data = get_material_data(material_name)
	if (!data):
		return
	crafting_material.data  = data
	
	return crafting_material

static func get_material_data(material_name) -> ItemData:
	var material_data = CRAFTING_MATERIALS.get(material_name)
	
	if !material_data:
		print("material doesn't exist!")
		return
	
	var data = ItemData.new()
	data.item_name = material_name
	data.xp_upgrade_values = material_data.xp_upgrade_values
	data.item_texture_path = material_data.item_texture
	
	return data
