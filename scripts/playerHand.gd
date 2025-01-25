extends Node

@export var Bullet : PackedScene = preload("res://scenes/bullets/bullet.tscn")

func shoot() -> void: 
	var bullet = Bullet.instantiate()
	bullet.transform = $Marker2D.global_transform
	owner.add_child(bullet)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _process(delta) -> void:
	if Input.is_action_just_pressed("mouseLeft"):
		shoot()
