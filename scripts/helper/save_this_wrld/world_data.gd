extends Resource
class_name WorldData

@export var seconds_elapsed: float = 0.0
@export var current_day: int = 0
@export var spawn_queue: Array = []
#ideally, a day cycle is 360s / 6m
