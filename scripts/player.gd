extends CharacterBody2D
class_name Player

@onready var inventory: Inventory = get_node("Inventory")
@onready var inventory_ui: Control = get_node("UiLayer/InventoryUi")

@export var stats: PlayerStats = null:
	set (value):
		stats = value
	get:
		return stats


var debugOpen: bool = false

enum PLAYER_MODE {
	PLAYABLE,
	IN_UI
}
var player_mode: = PLAYER_MODE.PLAYABLE

var detected_items: Array[Item]
var closest_item: Item = null

var closest_interactable: Interactable = null

var moving: bool = false

var current_ui: InteractableUi

@onready var light: PointLight2D = $PointLight2D

func _ready() -> void:
	print(ItemRecipeDatabase.get_item_recipes())

func open_ui(ui_screen: Control):
	$UiLayer.add_child(ui_screen)

func get_input() -> void:
	var input_direction: Vector2 = Vector2.ZERO
	if player_mode == PLAYER_MODE.PLAYABLE:
		input_direction = Input.get_vector("left", "right", "up", "down")
		if Input.is_action_just_pressed("pickUp"):
			if closest_item:
				inventory.pickup_item(closest_item)
			elif closest_interactable:
				interact(closest_interactable)
		if Input.is_action_just_pressed("mouseScrollDown"):
			inventory.switch_item(inventory.active_item_index + 1)
		elif Input.is_action_just_pressed("mouseScrollUp"):
			inventory.switch_item(inventory.active_item_index - 1)
		if Input.is_action_just_pressed("drop"):
			inventory.drop_item()
		if Input.is_action_just_pressed("escape"):
			open_pause_ui()
		if input_direction:
			moving = true
		else:
			moving = false
	velocity = input_direction * stats.SPEED

func open_pause_ui() -> void:
	$UiLayer/PauseUi.visible = true
	player_mode = PLAYER_MODE.IN_UI

func open_inventory_ui() -> void:
	inventory_ui.visible = !inventory_ui.visible
	#more stuff here?


var step_height = 25
var step_size = 20
var step_offset = 80
var body_offset = 30
var walking_animation_time: float = 0.0
func manage_walking_animation(delta):
	var step_speed = 10
	walking_animation_time += delta * step_speed
	if velocity.length() > 10:
		var move_dir = velocity.normalized()
		var side_dir = move_dir.orthogonal()
		
		$LeftFoot.position   = move_dir * step_size * sin(walking_animation_time) + side_dir * step_size * 0.3
		$LeftFoot.position.y -= step_height * cos(walking_animation_time) - step_offset
		
		$RightFoot.position = move_dir * step_size * sin(walking_animation_time + PI) - side_dir * step_size * 0.3
		$RightFoot.position.y -= step_height * cos(walking_animation_time + PI) - step_offset
		$Body.position.y = sin(walking_animation_time) + body_offset
	else:
		$LeftFoot.position = $LeftFoot.position.move_toward(Vector2(-step_size * 0.5, step_height), delta)
		$RightFoot.position = $RightFoot.position.move_toward(Vector2(step_size * 0.5, step_height), delta)
		$Body.position.y = sin(walking_animation_time) + body_offset

func _physics_process(delta: float) -> void:
	get_input()
	if !moving:
		$AnimationPlayer.play("idle")
	move_and_collide(velocity * delta)
	manage_walking_animation(delta)
	manage_hud()
	closest_item = get_closest_detected_item()
	#$Hand.look_at(get_global_mouse_position())
	#print(get_child_count())
	#print(scale.x)
	if (global_position.x - get_global_mouse_position().x > 1):
		$Body.flip_h = true
		$Head.flip_h = true
	else:
		$Body.flip_h = false
		$Head.flip_h = false

func interact(interactable: Interactable) -> void:
	interactable.instantiate_ui()
	$UiLayer.add_child(interactable.ui_instance)
	player_mode = PLAYER_MODE.IN_UI

func get_closest_detected_item() -> Item:
	var closest_detected_item: Item
	var closest_item_distance: float = INF
	for item in detected_items:
		var item_distance = (position - item.position).length_squared()
		if item_distance < closest_item_distance:
			closest_detected_item = item
			closest_item_distance = item_distance
	return closest_detected_item

func _on_item_detected(body: Node2D) -> void:
	if body is Item:
		detected_items.append(body)


func _on_item_undetected(body: Node2D) -> void:
	var index = detected_items.find(body)
	detected_items.remove_at(index)

func damage(dmg: float):
	stats.hp -= dmg
	modulate = Color(1, 0, 0)
	await get_tree().create_timer(0.1).timeout
	modulate = Color(1,1,1)
	if stats.hp <= 0:
		emit_signal("player_died")
		$Collision.disabled = true
	print(stats.hp)

signal player_died

func _on_open_debug_pressed() -> void:
	$UiLayer/DebugUi.visible = true
	player_mode = PLAYER_MODE.IN_UI

func manage_hud(): #TODO: break out later
	$UiLayer/TestUi/AspectRatioContainer/TextureProgressBar.max_value = stats.max_hp
	$UiLayer/TestUi/AspectRatioContainer/TextureProgressBar.value = stats.hp
