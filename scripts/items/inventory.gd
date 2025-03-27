extends Node

@export var items: Array[Item] = [] : 
	set (value):
		_set_items(value)
	get:
		return items
@export var active_item: Item
@export var active_item_index: int
@export var max_items: int = 9

@onready var player = get_parent()
@onready var inventory_label: Label = get_parent().get_node("UiLayer/TestUi/Inventory")
@onready var active_item_rect: TextureRect = get_parent().get_node("UiLayer/TestUi/TextureRect")

@onready var Item_Frame = preload("res://scenes/ui/item_frame.tscn")

func _ready() -> void:
	pass
	#set_inventory_label()

func set_inventory_label() -> void:
	if active_item:
		#inventory_label.text = active_item.item_name
		inventory_label.text = str(active_item.amount_in_stack)
		active_item_rect.texture = active_item.item_sprite.texture
	else:
		inventory_label.text = "no active item"
	
	var items_in_container = get_parent().get_node("UiLayer/TestUi/PanelContainer/VBoxContainer").get_children()
	for existing_item in items_in_container:
		existing_item.queue_free()
	for item in items:
		var item_frame: ItemFrame = Item_Frame.instantiate()
		item_frame.texture = item.item_sprite.texture
		item_frame.item_quantity = item.amount_in_stack
		if item != active_item:
			item_frame.self_modulate = Color(0, 0, 0,)
		else:
			item_frame.self_modulate = Color(10, 10, 10)
		get_parent().get_node("UiLayer/TestUi/PanelContainer/VBoxContainer").add_child(item_frame)
		
		'''
		elif items_in_container[items.find(item)] and item.item_name == items_in_container[items.find(item)].item_name:
			var item_frame: ItemFrame = Item_Frame.instantiate()
			item_frame.texture = item.item_texture
			get_parent().get_node("UiLayer/InventoryUi/VBoxContainer").add_child(item_frame)
			
		# aaaaaaaaughaadsfofifgyugogouhiuohoiuhu
		'''

func drop_item():
	if !active_item:
		return
	var index = items.find(active_item)
	items.remove_at(index)
	active_item.change_mode(Item.MODE.GROUND_ITEM)
	active_item.reparent(get_tree().get_root())
	if items.size() >= 1:
		active_item = items[index-1]
		active_item.global_transform = player.transform
		active_item.change_mode(Item.MODE.ACTIVE_ITEM)
		active_item.reparent(player)
	else:
		active_item = null
	set_inventory_label()

func subtract_item(item_name: String, amount: int):
	for item in items:
		if item_name == item.item_name:
			item.amount_in_stack = item.amount_in_stack - amount
		if item.amount_in_stack <= 0:
			items.remove_at(items.find(item))
			active_item = null
			switch_item(active_item_index + 1)
			item.queue_free()
	set_inventory_label()

func pickup_item(item: Item):
	if items.find(item) != -1:
		return
	
	var item_is_unique = true
	var new_item: Item
	for stashed_item in items:
		if item.item_name == stashed_item.item_name and stashed_item.stackable:
			stashed_item.amount_in_stack += item.amount_in_stack
			item_is_unique = false
			new_item = stashed_item
			break
		#print(stashed_item)
	
	if item_is_unique:
		items.append(item)
	
	if active_item:
		active_item.change_mode(Item.MODE.INVENTORY_ITEM)
	if items.size() > max_items:
		items.remove_at(items.find(active_item))
		active_item.change_mode(Item.MODE.GROUND_ITEM)
		active_item.reparent(get_tree().get_root())
	
	if !new_item:
		active_item = item
		active_item_index = items.find(active_item)
	else:
		active_item = new_item
		active_item_index = items.find(active_item)
		item.queue_free()
	
	active_item.global_transform = player.transform
	active_item.change_mode(Item.MODE.ACTIVE_ITEM)
	active_item.reparent(player)
	
	set_inventory_label()

func _set_items(value: Array[Item]):
	items = value

func _input(event) -> void:
	if event is InputEventKey:
		if event.pressed:
			# Map number keys 1-9 to item indices 0-8
			if int(event.as_text_key_label()) >= 1 and int(event.as_text_key_label()) <= 9:
				var index = int(event.as_text_key_label()) - 1
				if items.size() > int(event.as_text_key_label()):
					return
				switch_item(index)

func switch_item(index) -> void:
	#if !active_item:
	#	return
	if items.size() == 0:
		return
	#var index = active_item_index + 1
	if (index >= items.size()):
		index = 0
	elif (index < 0):
		index = items.size() - 1
	if active_item:
		active_item.change_mode(Item.MODE.INVENTORY_ITEM)
	active_item = items[index]
	active_item_index = index
	active_item.global_transform = player.transform
	active_item.change_mode(Item.MODE.ACTIVE_ITEM)
	active_item.reparent(player)
	
	set_inventory_label()
