extends TextureRect
class_name ItemFrame

@export var item_name: String
@export var item_quantity: int
#@onready var quantity_label = $Label

func _ready():
	if item_quantity <= 1:
		$Label.text = ""
	else:
		$Label.text = str(item_quantity)
