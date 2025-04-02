extends ItemData
class_name SeedData

@export var deceleration: float = 300
@export var initial_speed: float = 500
@export var growth_time: float = 5.0
@export var crop_name: String = "default"
@export var yield_min: int = 3
@export var yield_max: int = 7
@export var seed_drop_chance: float = 0.90
@export var seed_drop_min: int = 0
@export var seed_drop_max: int = 2
@export var seed_texture_path: String 
@export var seed_hp: float = 50.0
@export var seed_mode: Seed.SEED_MODE = Seed.SEED_MODE.ITEM

#item_type = ITEM_TYPE.SEED
