extends Resource
class_name ItemRecipeDatabase

const ITEM_RECIPES := {
	"potato_cannon":{
		"item_path":"res://scenes/items/weapons/ranged/potato_cannon.tscn",
		"item_texture":"res://assets/sprites/weapons/potato_cannon.png",
		"recipe":{
			"potato": 25
		},
		"accessible":true
	},
	"leek_sabre":{
		"item_path":"res://scenes/items/weapons/melee/leek_sabre.tscn",
		"item_texture":"res://assets/sprites/weapons/leek_sabre.png",
		"recipe":{
			"leek": 15
		},
		"accessible":true
	},
	"stefan":{
		"item_name":"stefan",
		"item_path":"res://icon.svg",
		"item_texture":"res://assets/sprites/stefan_vulic.jpg",
		"recipe":{
			"essence of stefan":1
		},
		"accessible":false
	}
}

static func create_item_recipe(item_name: String) -> ItemRecipe:
	var recipe_data = ITEM_RECIPES.get(item_name)
	if recipe_data:
		if recipe_data.accessible == false:
			return null
		var new_recipe = ItemRecipe.new()
		new_recipe.item_name = item_name
		new_recipe.item_path = recipe_data.item_path
		#var texture = Texture2D.new()
		#texture.resource_path = recipe_data.item_texture
		#new_recipe.item_texture = texture
		new_recipe.item_texture = load(recipe_data.item_texture)
		new_recipe.recipe = recipe_data.recipe
		return new_recipe
	return null

static func get_item_recipes() -> Array[ItemRecipe]:
	var recipes: Array[ItemRecipe] = []
	for item_recipe in ITEM_RECIPES.keys():
		var new_recipe = create_item_recipe(item_recipe)
		if new_recipe:
			recipes.append(new_recipe)
	return recipes
