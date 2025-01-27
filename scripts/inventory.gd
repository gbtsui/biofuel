extends Node

@export var items: Array[Item] = []
@export var active_item: Item
@export var max_items: int = 9

@onready var player = get_parent()

func _ready() -> void:
	print(player)

func pickup_item(item: Item):
	items.append(item)
	if active_item:
		active_item.change_mode(active_item.MODE.GROUND_ITEM)
		active_item.reparent(get_tree().get_root())
	active_item = item
	#get_parent().add_child(item)
	print(item)
	item.reparent(player)
	print(active_item)
	active_item.mode = active_item.MODE.ACTIVE_ITEM
	#print(player.get_child_count())
	#player.add_child(active_item)
	#print(player.get_child_count())
	#item.queue_free()
