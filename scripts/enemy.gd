extends CharacterBody2D
class_name Enemy

@export var hp: int = 100
@export var selfEffect := EFFECT.NORMAL
@export var effect_damage: float = 0
var effect_timer = 0
var effect_duration_timer = 0

enum EFFECT {
	NORMAL,
	FIRE,
	CORROSION,
	SLOW,
	FREEZE
}

func die() -> void:
	print("dead lol")
	modulate = Color("1f1e33")
	queue_free()

func damage(dmg: int) -> void:
	hp = hp - dmg
	modulate = Color("e20000")
	await get_tree().create_timer(0.1).timeout
	modulate = Color("ffffff")
	if (hp < 1):
		die()

func set_effect(effect, effect_duration, effect_damage):
	if (effect == EFFECT.FIRE):
		selfEffect = effect
		effect_duration_timer = effect_duration

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (selfEffect == EFFECT.FIRE && effect_timer < 0):
		modulate = Color("e20000")
		self.damage(effect_damage)
		print("fire damage :( ", effect_duration_timer)
	
	if effect_timer < 0:
		effect_timer = 1
	
	if (effect_duration_timer < 0):
		selfEffect = EFFECT.NORMAL
	
	effect_timer = effect_timer - delta
	effect_duration_timer = effect_duration_timer - delta
