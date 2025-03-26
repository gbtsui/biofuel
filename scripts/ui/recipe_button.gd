extends Button
class_name RecipeButton

@onready var label_text: String

func _ready():
	custom_minimum_size = Vector2(64, 64)
	$Label.text = label_text
	#size = Vector2(64, 64)
	expand_icon = true
