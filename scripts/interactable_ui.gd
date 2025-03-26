extends Control
class_name InteractableUi

@onready var player: Player = get_parent().get_parent() # get_tree().get_root().get_node("Player")

func _on_button_pressed() -> void:
	player.player_mode = Player.PLAYER_MODE.PLAYABLE
	queue_free()
