extends CharacterBody2D
class_name Enemy

@export var hp: int = 100

func die() -> void:
	print("dead lol")
	modulate = Color("1f1e33")
	queue_free()

func damage(dmg: int) -> void:
	hp = hp - dmg
	modulate = Color("e20000")
	await get_tree().create_timer(0.1).timeout
	modulate = Color("ffffff")
	if (hp < 1):
		die()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
