extends HBoxContainer
class_name MaterialRequirementDisplay

@export var material_texture: Texture2D
@export var needed: int
@export var owned: int

func _ready():
	$TextureRect.texture = material_texture
	$NeededLabel.text = str(needed)
	$OwnedLabel.text = "(" + str(owned) + ")"
	
	if owned >= needed:
		$OwnedLabel.add_theme_color_override("font_color", Color(0, 1, 0))
	else:
		$OwnedLabel.add_theme_color_override("font_color", Color(1, 0, 0))
