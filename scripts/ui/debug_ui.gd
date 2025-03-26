extends InteractableUi
class_name DebugUi

func _on_button_pressed():
	self.visible = false
	player.player_mode = Player.PLAYER_MODE.PLAYABLE
