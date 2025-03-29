extends HBoxContainer


func _spawn_enemy() -> void:
	var enemy_name = $VBoxContainer/EnemyName.text
	var data: EnemyData = EnemyDatabase.get_enemy_data(enemy_name)
	
	var instance: Enemy = data.enemy_scene.instantiate()
	instance.data = data
	
	get_tree().get_root().get_node("World").add_child(instance)


func _kill_all_enemies() -> void:
	var children = get_tree().get_root().get_node("World").get_children()
	for child in children:
		if child is Enemy:
			child.damage(INF)
