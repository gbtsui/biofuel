extends MeleeWeapon
class_name Scythe

func _ready():
	item_texture = load("res://assets/sprites/weapons/scythe.png")
	super()

func _on_tilled_dirt_detected(area: Area2D) -> void:
	if area is TilledDirt:
		area.harvest()
