extends InteractableUi

@export var selected_option: ItemRecipe = null
@export var options: Array[ItemRecipe] = []

@onready var craft_button: Button = $PanelContainer/ContentContainer/InformationContainer/TopContainer/VBoxContainer/CraftButton
@onready var stats_container: VBoxContainer = $PanelContainer/ContentContainer/InformationContainer/TopContainer/ScrollContainer/StatsContainer
@onready var materials_container: VBoxContainer = $PanelContainer/ContentContainer/InformationContainer/NinePatchRect/MaterialsScroll/MaterialsContainer

@onready var recipe_button = preload("res://scenes/ui/recipe_button.tscn")
@onready var stat_display = preload("res://scenes/ui/components/stat_display.tscn")
@onready var material_display = preload("res://scenes/ui/components/material_requirement_display.tscn")
@onready var valid_recipe_texture = preload("res://assets/sprites/ui/checkmark.png")
@onready var invalid_recipe_texture = preload("res://assets/sprites/ui/x.png")

func _ready():
	options = ItemRecipeDatabase.get_item_recipes()
	for option in options:
		var button = recipe_button.instantiate()
		#button.text = option.item_name
		button.icon = option.item_texture
		button.pressed.connect(set_selected_option.bind(option))
		$PanelContainer/ContentContainer/OptionsGridContainer.add_child(button)
	craft_button.disabled = true

func validate_recipe(item_recipe: ItemRecipe) -> bool:
	var remaining_requirements := {}
		
	for required_material in item_recipe.recipe.keys():
		remaining_requirements[required_material] = item_recipe.recipe[required_material]
	
	for player_item in player.inventory.items:
		if player_item.data.item_name in remaining_requirements:
			remaining_requirements[player_item.data.item_name] = remaining_requirements[player_item.data.item_name] - player_item.data.amount_in_stack
			
			#if player_item.amount_in_stack < required_amount:
			#	return false
	
	return remaining_requirements.values().all(func(x): return x <= 0)
	

func set_selected_option(option: ItemRecipe):
	selected_option = option
	#$ContentContainer/InformationContainer/ItemNameLabel.text = option.item_name
	#$ContentContainer/InformationContainer/ItemStatsLabel.text = str(option.recipe)
	
	if selected_option:
		craft_button.disabled = false
		craft_button.icon = valid_recipe_texture
		
	
	if !validate_recipe(option):
		craft_button.disabled = true
		craft_button.icon = invalid_recipe_texture
	
	for child in stats_container.get_children():
		child.queue_free()
	
	var stats = WeaponDatabase.get_weapon_data(option.item_name)
	var possible_fields = ["damage", "attack_speed", "knockback_magnitude"]
	for property in stats.get_property_list():
		if property.name in possible_fields:
			var display_instance: StatDisplay = stat_display.instantiate()
			display_instance.stat_type = property.name
			display_instance.value = stats[property.name]
			stats_container.add_child(display_instance)
	
	for child in materials_container.get_children():
		child.queue_free()
	
	for required_material in option.recipe.keys():
		var material_data: ItemData = CraftingMaterialDatabase.get_material_data(required_material)
		var display_instance: MaterialRequirementDisplay = material_display.instantiate()
		display_instance.material_texture = load(material_data.item_texture_path)
		display_instance.needed = option["recipe"][required_material]
		var owned: int
		
		var inventory_item: Array[Item] = player.inventory.items.filter(func(item: Item): return item.data.item_name == required_material)
		
		if inventory_item:
			owned = inventory_item[0].data.amount_in_stack
		else:
			owned = 0
		display_instance.owned = owned
		
		materials_container.add_child(display_instance)
	
	$PanelContainer/ContentContainer/InformationContainer/TopContainer/VBoxContainer/TextureRect.texture = option.item_texture
	'''
	for property in selected_weapon.data.get_property_list():
		if property.name in possible_fields:
			fields.append(property.name)
			var bar_instance: StatUpgradeBar = stat_upgrade_bar_scene.instantiate()
			bar_instance.stat_type = property.name
			bar_instance.current_xp = selected_weapon.data.xp[property.name+"_xp"]
			if selected_item:
				if property.name+"_xp" in selected_item.data.xp_upgrade_values.keys():
					bar_instance.added_xp = selected_item.data.xp_upgrade_values[property.name+"_xp"] * selected_item.data.amount_in_stack
			bar_instance.base_value = selected_weapon["data"][property.name]
			$PanelContainer/ContentContainer/InformationContainer/StatsScrollContainer/StatsContainer.add_child(bar_instance)

	'''


func _on_craft_button_pressed() -> void:
	for required_material in selected_option.recipe:
		#player.inventory.remove_stackable(required_material, selected_option.recipe[required_material])
		player.inventory.subtract_item(required_material, selected_option.recipe[required_material])
	var item_instance = load(selected_option.item_path).instantiate()
	item_instance.data = WeaponDatabase.get_weapon_data(selected_option.item_name) 
	get_tree().get_root().get_node("World").add_child(item_instance)
	player.inventory.pickup_item(item_instance)
	_on_button_pressed()
