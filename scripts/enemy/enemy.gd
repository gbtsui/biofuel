extends CharacterBody2D
class_name Enemy

@export var data: EnemyData = null:
	set(value):
		data = value
	get:
		return data


@export var target_distance_threshold = 100 # TODO: move this into data btw
@export var plot_distance_threshold = 50

@export var selfEffect := Bullet.BULLET_EFFECT.NORMAL
@export var effect_damage: float = 0
var effect_timer: float = 0
# @export var pathfind_mode: PATHFIND_MODE = PATHFIND_MODE.SEARCH_PLAYER

@onready var hurtbox = $Hurtbox


@onready var player = get_tree().get_root().get_node("World/Player")

@onready var steering_agent: SteeringAgent = SteeringAgent.new()

var current_target = null

var knockback_vector: Vector2 = Vector2.ZERO

var num_rays = 16

var ray_directions = []
var interest = []
var danger = []

var chosen_dir = Vector2.ZERO

enum PATHFIND_MODE {
	WALKING,
	ATTACKING
}

enum PATHFIND_TYPE {
	HARVESTER,
	SOLDIER,
	ESCORT
}

func die() -> void:
	#handle item drop stuff here ig???
	for drop in data.drops.keys():
		var seed_drops = data.drops.seeds
		for seed in seed_drops.keys():
			if randf() < seed_drops[seed]["chance"]:
				for instance in randi_range(seed_drops[seed]["min"], seed_drops[seed]["max"]):
					var new_instance = SeedDatabase.get_seed(seed)
					new_instance.global_position = self.global_position
					get_tree().get_root().get_node("World").add_child(new_instance)
				break
	
	modulate = Color("1f1e33")
	get_tree().get_root().get_node("World/GameController").remove_enemy(self)
	queue_free()
	

func damage(dmg: float) -> void:
	data.hp = data.hp - dmg
	modulate = Color("e20000")
	await get_tree().create_timer(0.1).timeout
	modulate = Color("ffffff")
	if (data.hp < 1):
		die()

func set_effect(effect, effect_duration, effect_damage):
	self.selfEffect = effect
	self.effect_timer = effect_duration
	self.effect_damage = effect_damage

func find_target():
	var target_controller: TargetController = get_tree().get_root().get_node("World").target_controller
	var plot_target = target_controller.get_best_plot_target(self.position)
	if !plot_target:
		current_target = player
	else:
		if (data.plot_target_weight == 0):
			current_target = player
		elif (data.player_target_weight == 0):
			current_target = plot_target
		else:
			var weighted_tar_dist = self.global_position.distance_squared_to(plot_target.global_position / data.plot_target_weight)
			var weighted_player_dist = self.global_position.distance_squared_to(player.global_position) / data.player_target_weight
			#$DebugLabel2.text = str(weighted_tar_dist) + " : " + str(weighted_player_dist)
			current_target = player if weighted_player_dist < weighted_tar_dist else plot_target
	
	if self.global_position.distance_to(current_target.global_position) < target_distance_threshold and current_target == player:
		current_target = null
		return
	elif self.global_position.distance_to(current_target.global_position) < plot_distance_threshold and current_target is TilledDirt:
		current_target = null
		return
func _ready() -> void:
	#find_target()
	self.add_child(steering_agent)
	interest.resize(num_rays)
	danger.resize(num_rays)
	ray_directions.resize(num_rays)
	for i in num_rays:
		var angle: float = i * 2 * PI / num_rays
		ray_directions[i] = Vector2.RIGHT.rotated(angle)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if effect_timer < 0:
		effect_timer = 1
		match selfEffect:
			Bullet.BULLET_EFFECT.NORMAL:
				self.data.currentSpeed = data.baseSpeed
			Bullet.BULLET_EFFECT.FIRE:
				modulate = Color("e20000")
				self.damage(effect_damage)
			Bullet.BULLET_EFFECT.CORROSION:
				self.damage(effect_damage)
				self.data.currentSpeed = data.baseSpeed * 0.75
			Bullet.BULLET_EFFECT.SLOW:
				self.data.currentSpeed = data.baseSpeed * 0.25
	
	if (effect_timer < 0):
		selfEffect = Bullet.BULLET_EFFECT.NORMAL
	
	effect_timer -= delta
	'''
	if pathfind_mode == PATHFIND_MODE.SEARCH_PLAYER:
		var player = get_tree().get_root().get_node("World/Player")
		var direction = (player.position - position).normalized()
		velocity = knockback_vector if knockback_vector else (direction * currentSpeed)
		knockback_vector = knockback_vector.move_toward(Vector2.ZERO, delta * 1000)
		move_and_slide()
		if (player.position - position).length() < 100:
			attack()
	'''
	find_target()
	if current_target:
		var seek_force = steering_agent.seek(self.global_position, current_target.global_position, velocity, 1) 
		var avoid_force = steering_agent.avoid_obstacles(self.global_position, velocity, 5, 16) * data.currentSpeed * delta
		var steering = seek_force + avoid_force
		#$DebugLabel2.text = str(seek_force) + " " + str(avoid_force)
		velocity += steering
		velocity = velocity.normalized() * data.currentSpeed * delta
		
		seek = seek_force
		avoid = avoid_force
		handle_walk_animation(delta)
		#velocity = self.global_position.direction_to(current_target.global_position) * currentSpeed * delta
	else:
		attack()
		velocity = Vector2.ZERO

	knockback_vector = knockback_vector.move_toward(Vector2.ZERO, delta * 1000)
	velocity = knockback_vector * delta if knockback_vector else velocity
	move_and_collide(velocity)
	queue_redraw()
	
	#$Label.text = str(hp)

func handle_walk_animation(delta: float):
	if knockback_vector:
		return
	
	if velocity.normalized().x >= 0:
		$SpriteContainer.scale = Vector2(-1, 1)
	elif velocity.normalized().x <= 0:
		$SpriteContainer.scale = Vector2(1, 1)


var seek = Vector2.ZERO
var avoid = Vector2.ZERO

func _draw() -> void:
	draw_line(Vector2.ZERO, seek, Color(0,1,0))
	draw_line(Vector2.ZERO, avoid, Color(1,0,0))
	draw_line(Vector2.ZERO, velocity, Color(0,0,0))

func attack() -> void:
	$SpriteContainer/AnimationPlayer.play("attack")
	#await get_tree().create_timer($SpriteContainer/AnimationPlayer.get_animation("attack").length)
	# add a finite state machine ashdiohfaoidshudafsfdsa

func heal(amount: float):
	pass

func _on_hurtbox_body_entered(body: Node2D) -> void:
	if body is Player:
		body.damage(data.attack_damage)

func _on_hurtbox_area_entered(area: Area2D) -> void:
	if area is TilledDirt:
		area.damage(data.plot_attack_damage)
	pass
	
func knockback(direction: Vector2, magnitude: float):
	#committing crimes with direction and magnitude, OH YEAH
	knockback_vector = (direction * magnitude)/data.weight
	#w$DebugLabel2.text = str(magnitude)
	pass
