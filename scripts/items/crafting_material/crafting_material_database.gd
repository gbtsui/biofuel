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
			"attack_speed_xp":10
		},
		"item_texture": "res://assets/sprites/plants/carrot.png",
	},
	"beetroot": {
		"is_crop": true,
		"xp_upgrade_values": {
			"damage_xp":1.5
		},
		"item_texture": "res://assets/sprites/plants/beetroot.png"
	},
	"sugarcane":{
		"is_crop":true,
		"xp_upgrade_values": {
			"attack_speed_xp":1.5
		},
		"item_texture": "res://assets/sprites/plants/sugarcane.png"
	}
}


static func append_material_data(crafting_material: CraftingMaterial, material_name: String) -> CraftingMaterial:
	var material_data = CRAFTING_MATERIALS.get(material_name)
	
	if !material_data:
		push_error("material " + material_name + " doesnt exist!")
	
	print(material_data)
	
	crafting_material.item_name = material_name
	crafting_material.xp_upgrade_values = material_data.xp_upgrade_values
	crafting_material.item_texture = load(material_data.item_texture)
	
	return crafting_material
