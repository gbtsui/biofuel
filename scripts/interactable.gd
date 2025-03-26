extends StaticBody2D
class_name Interactable

var interactable = false
@onready var ui: PackedScene = preload("res://scenes/ui/free_potatoes.tscn")
@onready var ui_instance: Control
@onready var player = get_tree().get_root().get_node("World/Player")

func _process(delta):
	if interactable:
		$Sprite2D.modulate = Color(0,0,0)
	else:
		$Sprite2D.modulate = Color(1,1,1)

func instantiate_ui():
	ui_instance = ui.instantiate()
	ui_instance.get_node("CloseButton").connect("pressed", close_ui)

func close_ui():
	ui_instance = null

func _on_player_detector_body_entered(body: Node2D) -> void:
	if body is Player:
		body.closest_interactable = self

func _on_player_detector_body_exited(body: Node2D) -> void:
	if body is Player:
		body.closest_interactable = null
