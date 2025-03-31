extends Control

@onready var world = preload("res://testWorld.tscn")

func _continue_game() -> void:
	get_tree().change_scene_to_packed(world)
