extends Control

@onready var world = preload("res://testWorld.tscn")

func _continue_game() -> void:
	get_tree().change_scene_to_packed(world)

func _ready() -> void:
	if SaveGame.save_exists():
		$VBoxContainer/ContinueButton.disabled = false

func _on_close_button_pressed() -> void:
	get_tree().quit()

func _on_new_button_pressed() -> void:
	SaveGame.delete_save("default path") #TODO: heuristic, change later :P
	_continue_game()
