extends InteractableUi

var items: Array[Item] 
var weapons: Array[Weapon]

var selected_weapon: Weapon
#var selected_items: Array[Item]
var selected_item: Item
var compatible: bool = true

@onready var weapons_grid = $PanelContainer/ContentContainer/ItemsContainer/ScrollContainer/WeaponsGrid
@onready var upgrade_items_container = $PanelContainer/ContentContainer/ItemsContainer/ScrollContainer2/UpgradeItemsContainer

@onready var stat_upgrade_bar_scene = preload("res://scenes/ui/components/stat_upgrade_bar.tscn")
@onready var Recipe_Button = preload("res://scenes/ui/recipe_button.tscn")

var upgrade_bars: Array[StatUpgradeBar] = []

func _ready() -> void:
	update_grid()

func update_grid():
	items = player.inventory.items
	for child in weapons_grid.get_children():
		child.queue_free()
	for child in upgrade_items_container.get_children():
		child.queue_free()
	for item in items:
		var recipe_button = Recipe_Button.instantiate()
		recipe_button.icon = item.item_sprite.texture
		
		if item is Weapon:
			weapons.append(item)
			recipe_button.pressed.connect(set_selected_weapon.bind(item))
			weapons_grid.add_child(recipe_button)
		elif item is CraftingMaterial:
			recipe_button.label_text = str(item.data.amount_in_stack)
			recipe_button.pressed.connect(add_selected_item.bind(item))
			upgrade_items_container.add_child(recipe_button)

func update_button():
	compatible = validate_xp_fields()
	#$PanelContainer/ContentContainer/InformationContainer/Overview/UpgradeButton.disabled = false if selected_weapon and selected_items and compatible else true
	$PanelContainer/ContentContainer/InformationContainer/Overview/UpgradeButton.disabled = false if selected_weapon and selected_item and compatible else true

func add_selected_item(item: CraftingMaterial):
	#if selected_items.size() < 6 and item not in selected_items:
	#	selected_items.append(item)
	#	print(selected_items)
	selected_item = item
	update_button()
	update_weapon_label()

func validate_xp_fields() -> bool:
#	if selected_weapon:
#		for item in selected_items:
#			for key in item.data.xp_upgrade_values.keys():
#				if !selected_weapon.data.xp.has(key):
#					return false
#		return true
#	else:
#		return false
	if selected_weapon and selected_item:
		for key in selected_item.data.xp_upgrade_values.keys():
			if !selected_weapon.data.xp.has(key):
				return false
		return true
	else:
		return false

func update_weapon_label():
	#$ContentContainer/InformationContainer/WeaponNameLabel.text = selected_weapon.data.item_name
	$PanelContainer/ContentContainer/InformationContainer/Overview/WeaponIcon.set_texture(selected_weapon.item_sprite.texture)
	if selected_item:
		$PanelContainer/ContentContainer/InformationContainer/Overview/MaterialIcon.set_texture(selected_item.item_sprite.texture)
	else:
		$PanelContainer/ContentContainer/InformationContainer/Overview/MaterialIcon.set_texture(null)
	upgrade_bars = []
	for child in $PanelContainer/ContentContainer/InformationContainer/StatsScrollContainer/StatsContainer.get_children():
		child.queue_free()
	var possible_fields = ["damage", "attack_speed", "knockback_magnitude"]
	var fields = []
	
	for property in selected_weapon.data.get_property_list():
		if property.name in possible_fields:
			fields.append(property.name)
			var bar_instance: StatUpgradeBar = stat_upgrade_bar_scene.instantiate()
			bar_instance.stat_type = property.name
			bar_instance.current_xp = selected_weapon.data.xp[property.name+"_xp"]
			if selected_item:
				if property.name+"_xp" in selected_item.data.xp_upgrade_values.keys():
					bar_instance.added_xp = selected_item.data.xp_upgrade_values[property.name+"_xp"] * selected_item.data.amount_in_stack
			bar_instance.base_value = selected_weapon["data"][property.name]
			$PanelContainer/ContentContainer/InformationContainer/StatsScrollContainer/StatsContainer.add_child(bar_instance)
	'''
	$ContentContainer/InformationContainer/DamageLabel.text = str(XPModifier.get_level("damage", selected_weapon.data.xp["damage_xp"])) + " " + str(selected_weapon.data.xp["damage_xp"])
	$ContentContainer/InformationContainer/DamageProgress.value = selected_weapon.data.xp["damage_xp"]
	$ContentContainer/InformationContainer/DamageProgress.max_value = XPModifier.get_xp_to_next_level("damage_xp", selected_weapon.data.xp["damage_xp"]) + selected_weapon.data.xp["damage_xp"]
	$ContentContainer/InformationContainer/DamageProgress.min_value = pow(XPModifier.get_level("damage", selected_weapon.data.xp["damage_xp"]), 2) * 10
	
	$ContentContainer/InformationContainer/AttackSpeedLabel.text = str(XPModifier.get_level("attack_speed", selected_weapon.data.xp["attack_speed_xp"]))
	$ContentContainer/InformationContainer/KnockbackLabel.text = str(XPModifier.get_level("knockback_magnitude", selected_weapon.data.xp["knockback_magnitude_xp"]))
	$ContentContainer/InformationContainer/ElementalDamageLabel.text = str(XPModifier.get_level("elemental_damage_xp", selected_weapon.data.xp["elemental_damage_xp"]))
	$ContentContainer/InformationContainer/ElementalDamageDurationLabel.text = str(XPModifier.get_level("elemental_damage_duration_xp", selected_weapon.data.xp["elemental_damage_duration_xp"]))
	'''

func set_selected_weapon(weapon: Weapon):
	selected_weapon = weapon
	update_weapon_label()
	update_button()

func _on_upgrade_button_pressed() -> void:
	#for item in selected_items:
	#	selected_weapon.add_xp(item.data.xp_upgrade_values, item.data.amount_in_stack)
	#	selected_items.remove_at(selected_items.find(item))
	#	player.inventory.subtract_item(item.data.item_name, item.data.amount_in_stack)
	
	selected_weapon.add_xp(selected_item.data.xp_upgrade_values, selected_item.data.amount_in_stack)
	player.inventory.subtract_item(selected_item.data.item_name, selected_item.data.amount_in_stack)
	selected_item = null
	
	update_button()
	update_grid()
	update_weapon_label()
