extends Resource
class_name TilledDirtData

@export var harvestable: bool = false
@export var current_crop: String = ""
@export var yield_min: int
@export var yield_max: int
@export var seed_drop_chance: float
@export var seed_drop_min: int
@export var seed_drop_max: int
@export var crop_hp: float

@export var plot_global_position: Vector2
