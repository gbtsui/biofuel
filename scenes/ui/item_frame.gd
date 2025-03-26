extends TextureRect
class_name ItemFrame

@export var item_name: String
@export var item_quantity: int
#@onready var quantity_label = $Label

func _ready():
	$Label.text = str(item_quantity)
