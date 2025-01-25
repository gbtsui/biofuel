extends CharacterBody2D
class_name Bullet

@export var speed: float = 400.0
@export var damage: int = 10

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	velocity = speed * Vector2(cos(global_rotation), sin(global_rotation))

func deleteBullet() -> void:
	queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	move_and_slide()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if (body is Enemy):
		body.damage(damage)
		deleteBullet()
