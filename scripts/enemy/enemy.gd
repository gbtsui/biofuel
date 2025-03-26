extends CharacterBody2D
class_name Enemy

@export var hp: int = 100
@export var baseSpeed = 200
@export var currentSpeed = 200

@export var weight = 1

@export var player_target_weight = 1
@export var plot_target_weight = 1

@export var target_distance_threshold = 100

@export var selfEffect := EFFECT.NORMAL
@export var effect_damage: float = 0
var effect_timer = 0
var effect_duration_timer = 0
# @export var pathfind_mode: PATHFIND_MODE = PATHFIND_MODE.SEARCH_PLAYER

@onready var hurtbox = $Hurtbox

@export var attack_damage: float = 10.0

@onready var player = get_tree().get_root().get_node("World/Player")

@onready var steering_agent: SteeringAgent = SteeringAgent.new()

var current_target = null

var knockback_vector: Vector2 = Vector2.ZERO

var num_rays = 16

var ray_directions = []
var interest = []
var danger = []

var chosen_dir = Vector2.ZERO

enum EFFECT {
	NORMAL,
	FIRE,
	CORROSION,
	SLOW,
	FREEZE
}

enum PATHFIND_MODE {
	SEARCH_PLAYER,
	SEARCH_CROP,
	ATTACKING
}

enum PATHFIND_TYPE {
	HARVESTER,
	SOLDIER,
	ESCORT
}

func die() -> void:
	modulate = Color("1f1e33")
	queue_free()

func damage(dmg: int) -> void:
	hp = hp - dmg
	modulate = Color("e20000")
	await get_tree().create_timer(0.1).timeout
	modulate = Color("ffffff")
	if (hp < 1):
		die()

func set_effect(effect, effect_duration, effect_damage):
	if (effect == EFFECT.FIRE):
		selfEffect = effect
		effect_duration_timer = effect_duration

func find_target():
	var target_controller: TargetController = get_tree().get_root().get_node("World").target_controller
	var plot_target = target_controller.get_best_plot_target(self.position)
	if !plot_target:
		current_target = player
	else:
		var weighted_tar_dist = self.global_position.distance_squared_to(plot_target.global_position / plot_target_weight)
		var weighted_player_dist = self.global_position.distance_squared_to(player.global_position) / player_target_weight
		$DebugLabel2.text = str(weighted_tar_dist) + " : " + str(weighted_player_dist)
		current_target = player if weighted_player_dist < weighted_tar_dist else plot_target
	
	if self.global_position.distance_to(current_target.global_position) < target_distance_threshold:
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
			EFFECT.NORMAL:
				self.currentSpeed = baseSpeed
			EFFECT.FIRE:
				modulate = Color("e20000")
				self.damage(effect_damage)
			EFFECT.CORROSION:
				self.damage(effect_damage)
				self.currentSpeed = baseSpeed * 0.75
			EFFECT.SLOW:
				self.currentSpeed = baseSpeed * 0.25
	
	if (effect_duration_timer < 0):
		selfEffect = EFFECT.NORMAL
	
	effect_timer = effect_timer - delta
	effect_duration_timer = effect_duration_timer - delta
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
		var avoid_force = steering_agent.avoid_obstacles(self.global_position, velocity, 1, 16) * currentSpeed * delta
		var steering = seek_force + avoid_force
		#$DebugLabel2.text = str(seek_force) + " " + str(avoid_force)
		velocity += steering
		velocity = velocity.normalized() * currentSpeed * delta
		
		seek = seek_force
		avoid = avoid_force
		#velocity = self.global_position.direction_to(current_target.global_position) * currentSpeed * delta
	else:
		velocity = Vector2.ZERO
	move_and_collide(velocity)
	queue_redraw()
	
	$Label.text = str(hp)

var seek = Vector2.ZERO
var avoid = Vector2.ZERO

func _draw() -> void:
	draw_line(Vector2.ZERO, seek, Color(0,1,0))
	draw_line(Vector2.ZERO, avoid, Color(1,0,0))
	draw_line(Vector2.ZERO, velocity, Color(0,0,0))

func attack() -> void:
	$AnimationPlayer.play("attack")
	# add a finite state machine ashdiohfaoidshudafsfdsa

func _on_hurtbox_body_entered(body: Node2D) -> void:
	if body is Player:
		body.damage(attack_damage)

func knockback(direction: Vector2, magnitude: float):
	#committing crimes with direction and magnitude, OH YEAH
	knockback_vector = (direction * magnitude)/weight
	$DebugLabel2.text = str(magnitude)
	pass
