extends CharacterBody2D

@export var SPEED : float = 300.0
@onready var hand: Node2D = get_node("Hand")
@onready var inventory: Node = get_node("Inventory")

var detected_items: Array[Item]
var closest_item: Item = null

func get_input() -> void:
	var input_direction = Input.get_vector("left", "right", "up", "down")
	if Input.is_action_just_pressed("pickUp"):
		inventory.pickup_item(closest_item)
	velocity = input_direction * SPEED

func _physics_process(delta: float) -> void:
	get_input()
	move_and_slide()
	closest_item = get_closest_detected_item()
	$Hand.look_at(get_global_mouse_position())
	#print(get_child_count())

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
