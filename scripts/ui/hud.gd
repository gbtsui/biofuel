extends Control
class_name PlayerHUD

@onready var time_label = $TopRightHud/Time
@onready var day_label = $TopRightHud/Day
@onready var bug_count_label = $TopRightHud/BugCount

@onready var player: Player = get_tree().get_root().get_node("World/Player")
@onready var game_controller: GameController = get_tree().get_root().get_node("World/GameController")

var infinity = "∞"

func _process(delta: float) -> void:
	var seconds_today = (floori(game_controller.data.seconds_elapsed) + 90) % 360
	
	var hours = floori(seconds_today / 15)
	var minutes = floori((seconds_today % 15) / 15.0 * 60 / 10) * 10
	
	var minutes_text = "00" if minutes == 0 else str(minutes)
	time_label.text = str(hours) + ":" + minutes_text
	day_label.text = str(game_controller.data.current_day)#str(floori(game_controller.data.seconds_elapsed + 90))
	bug_count_label.text = str(game_controller.current_enemies.size())
