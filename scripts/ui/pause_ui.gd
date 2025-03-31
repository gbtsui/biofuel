extends InteractableUi

signal exit_game

@onready var debug_menu = preload("res://scenes/ui/debug_ui.tscn")

func _ready():
	var game_controller = get_tree().get_root().get_node("World/GameController")
	exit_game.connect(game_controller.quit_game)

func _on_exit_button_pressed() -> void:
	emit_signal("exit_game")

func _on_open_debug_button_pressed() -> void:
	get_parent().add_child(debug_menu.instantiate())
	get_parent().get_node("OpenDebug").visible = true
	$PanelContainer/OpenDebugButton.queue_free()
	self.visible = false

func _on_button_pressed():
	self.visible = false
	player.player_mode = Player.PLAYER_MODE.PLAYABLE
