extends Item
class_name Weapon

var fireable: bool = true

func _ready() -> void:
	super()
	$CooldownTimer.wait_time = data.attack_speed
	#$CooldownTimer.start()

func reset_cooldown_timer(wait_time) -> void:
	$CooldownTimer.wait_time = wait_time
	$CooldownTimer.start()
	fireable = false

func _process(delta: float) -> void:
	super(delta)
	#print($CooldownTimer.time_left)

func _on_cooldown_timer_timeout() -> void:
	fireable = true
