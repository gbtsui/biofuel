extends Node2D
class_name SteeringAgent

func seek(current_position: Vector2, target_position: Vector2, velocity: Vector2, max_force: float) -> Vector2:
	var desired = current_position.direction_to(target_position)
	var steer = (desired)# - velocity) #.clampf(0, max_force)
	return steer

var rays = []
var ray_colors = []

func avoid_obstacles(current_position: Vector2, velocity: Vector2, max_force: float, ray_count: int) -> Vector2:
	var ray_length = 100
	var avoidance = Vector2.ZERO
	
	for i in range(ray_count):
		var angle = deg_to_rad((360/ray_count) * i)
		var dir = velocity.rotated(angle).normalized()
		var towards = (current_position + dir) * ray_length
		#var params = PhysicsRayQueryParameters2D.create(current_position, towards, 10, [self])
		var params = PhysicsRayQueryParameters2D.create(current_position, current_position + dir * ray_length)
		params.collide_with_bodies = true
		params.collision_mask = 10
		params.exclude = [get_parent()]
		#var collision = get_world_2d().direct_space_state.intersect_ray(params)
		var collision = get_world_2d().direct_space_state.intersect_ray(params)
		#rays.append(dir * ray_length)
		#if collision:
		#	ray_colors.append(Color(1,0,0))
		#else:
		#	ray_colors.append(Color(0,1,1))
		
		if collision:
			var distance = current_position.distance_to(collision.position)
			var distance_factor = clampf(1.0 - (distance / ray_length), 0.0, 1.0)
			var scaled_force = max_force * distance_factor
			
			avoidance -= dir * scaled_force
	return avoidance.normalized() * max_force

func _draw():
	for ray in rays.size():
		draw_line(Vector2.ZERO, rays[ray], ray_colors[ray])
	rays = []
	ray_colors = []

func _process(delta):
	queue_redraw()
