extends CharacterBody2D

@export var SPEED : float = 300.0

@onready var hand: Node2D = get_node("Hand")

func get_input() -> void:
	var input_direction = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * SPEED

func _physics_process(delta: float) -> void:
	get_input()
	hand.look_at(get_global_mouse_position())
	move_and_slide()
