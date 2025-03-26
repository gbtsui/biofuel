extends InteractableUi

@export var selected_option: ItemRecipe = null
@export var options: Array[ItemRecipe] = []

@onready var craft_button = $ContentContainer/InformationContainer/CraftButton

@onready var recipe_button = preload("res://scenes/ui/recipe_button.tscn")

func _ready():
	options = ItemRecipeDatabase.get_item_recipes()
	for option in options:
		var button = recipe_button.instantiate()
		#button.text = option.item_name
		button.icon = option.item_texture
		button.pressed.connect(set_selected_option.bind(option))
		$ContentContainer/OptionsGridContainer.add_child(button)
	craft_button.disabled = true

func validate_recipe(item_recipe: ItemRecipe) -> bool:
	var remaining_requirements := {}
		
	for required_material in item_recipe.recipe.keys():
		remaining_requirements[required_material] = item_recipe.recipe[required_material]
	
	for player_item in player.inventory.items:
		if player_item.item_name in remaining_requirements:
			remaining_requirements[player_item.item_name] = remaining_requirements[player_item.item_name] - player_item.amount_in_stack
			
			#if player_item.amount_in_stack < required_amount:
			#	return false
	
	return remaining_requirements.values().all(func(x): return x <= 0)
	

func set_selected_option(option: ItemRecipe):
	selected_option = option
	$ContentContainer/InformationContainer/ItemNameLabel.text = option.item_name
	$ContentContainer/InformationContainer/ItemStatsLabel.text = str(option.recipe)
	
	if selected_option:
		craft_button.disabled = false
	
	if !validate_recipe(option):
		craft_button.disabled = true


func _on_craft_button_pressed() -> void:
	for required_material in selected_option.recipe:
		#player.inventory.remove_stackable(required_material, selected_option.recipe[required_material])
		player.inventory.subtract_item(required_material, selected_option.recipe[required_material])
	var item_instance = load(selected_option.item_path).instantiate()
	get_tree().get_root().add_child(item_instance)
	player.inventory.pickup_item(item_instance)
	_on_button_pressed()
