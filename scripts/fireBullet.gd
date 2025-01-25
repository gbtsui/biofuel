extends Bullet

func _ready():
	bullet_effect = BULLET_EFFECT.FIRE
	bullet_effect_duration = 3.0
	bullet_effect_damage = 5
	damage = 20
	speed = 400
	setVelocity()
