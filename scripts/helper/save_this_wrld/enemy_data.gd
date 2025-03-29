extends Resource
class_name EnemyData

@export var enemy_scene_path: String
@export var enemy_scene: PackedScene
@export var enemy_global_position: Vector2
@export var enemy_type: int

@export var hp: float = 50
@export var max_hp: float = 50
@export var baseSpeed: float = 200
@export var currentSpeed: float = 200

@export var weight:float = 1
@export var player_target_weight: float = 1
@export var plot_target_weight:float = 1
@export var attack_damage: float = 5.0
@export var plot_attack_damage: float = 10.0
