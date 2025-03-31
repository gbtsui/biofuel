extends HBoxContainer


func _spawn_enemy() -> void:
	var enemy_name = $VBoxContainer/EnemyName.text
	var game_controller:GameController = get_tree().get_root().get_node("World/GameController")
	var enemy_data = EnemyDatabase.get_enemy_data(enemy_name)
	game_controller.spawn_enemy(enemy_data, Vector2.ZERO)


func _kill_all_enemies() -> void:
	var children = get_tree().get_root().get_node("World").get_children()
	for child in children:
		if child is Enemy:
			child.damage(INF)
