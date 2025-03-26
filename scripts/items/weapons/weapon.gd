extends Item
class_name Weapon

@export var cooldown: float = 0.5
#var cooldown_timer: float = 0.0
var fireable: bool = false

func _ready() -> void:
	super()
	$CooldownTimer.wait_time = cooldown
	$CooldownTimer.start()

func reset_cooldown_timer(wait_time) -> void:
	$CooldownTimer.wait_time = wait_time
	$CooldownTimer.start()
	fireable = false

func _process(delta: float) -> void:
	super(delta)
	#print($CooldownTimer.time_left)

func _on_cooldown_timer_timeout() -> void:
	fireable = true
