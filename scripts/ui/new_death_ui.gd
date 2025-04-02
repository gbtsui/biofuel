extends InteractableUi

func _on_exit() -> void:
	SaveGame.delete_save("placeholder") #TODO: fix this
	get_tree().change_scene_to_file("res://scenes/ui/title_screen.tscn")

func _ready() -> void:
	get_tree().paused = false
