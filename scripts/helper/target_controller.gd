extends Node
class_name TargetController
@onready var targets = []
@onready var player = get_tree().get_root().get_node("World/Player")

func add_target(target: Node2D):
	if (targets.find(target) == -1):
		targets.append(target)

func _ready() -> void:
	if !player:
		print("player not found :(")
	for child in get_parent().get_children():
		if child is TilledDirt and child.has_method("current_crop") and child.current_crop:
			add_target(child)

func remove_target(target: Node2D):
	targets.remove_at(targets.find(target))

func get_best_plot_target(enemy_position: Vector2, player_radius: float = 100) -> Node2D:
	var best_target = null
	var best_score = INF
	for plot in targets:
		if plot is TilledDirt:
			var dist_score = enemy_position.distance_squared_to(plot.global_position)
			if dist_score < best_score and player.global_position.distance_to(plot.global_position) > player_radius:
				best_score = dist_score
				best_target = plot
	return best_target
