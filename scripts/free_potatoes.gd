extends InteractableUi

@onready var test_potato_cannon = preload("res://scenes/items/weapons/ranged/potato_cannon.tscn")

func _ready():
	$InventoryLabel.text = str(player.inventory.stackables)

func update_label():
	$InventoryLabel.text = str(player.inventory.stackables)
	if !"potato" in player.inventory.stackables:
		return
	if player.inventory.stackables["potato"] >= 30:
		$CannonButton.disabled = false
	else:
		$CannonButton.disabled = true

func _on_potat_button_pressed() -> void:
	player.inventory.add_stackable("potato", 1)
	update_label()

func _on_cannon_button_pressed() -> void:
	player.inventory.add_stackable("potato", -30)
	var cannon_instance = test_potato_cannon.instantiate()
	get_tree().get_root().add_child(cannon_instance)
	player.inventory.pickup_item(cannon_instance)
	update_label()
	_on_button_pressed()
