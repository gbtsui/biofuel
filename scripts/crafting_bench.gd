extends Interactable
class_name CraftingBench

func _ready() -> void:
	ui = preload("res://scenes/ui/crafting_bench_ui.tscn")

func instantiate_ui():
	super()
