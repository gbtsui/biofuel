extends CharacterBody2D
class_name Bullet

@export var speed: float = 750.0
@export var damage: int = 10

@export var bullet_effect = BULLET_EFFECT.NORMAL
@export var bullet_effect_duration: float = 0
@export var bullet_effect_damage: float = 0


enum BULLET_EFFECT {
	NORMAL,
	FIRE,
	CORROSION,
	SLOW,
	FREEZE
}

func setVelocity():
	velocity = speed * Vector2(cos(global_rotation), sin(global_rotation))


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	setVelocity()

func deleteBullet() -> void:
	queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	move_and_slide()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if (body is Enemy):
		body.damage(damage)
		body.set_effect(bullet_effect, bullet_effect_duration, bullet_effect_damage)
		deleteBullet()
	elif (body is StaticBody2D):
		deleteBullet()
