extends Enemy
class_name BlankAphid

var legs = []
var leg_initial_positions = []

func _ready():
	super()
	for leg in $SpriteContainer/BackLegContainer.get_children():
		legs.append(leg)
		leg_initial_positions.append(leg.position)
	for leg in $SpriteContainer/FrontLegContainer.get_children():
		legs.append(leg)
		leg_initial_positions.append(leg.position)

var step_height = 3
var step_size = 5
var walking_animation_time = 0.0
var offset = 1
var step_speed = 5
func handle_walk_animation(delta):
	super(delta)
	for i in range(legs.size()):
		walking_animation_time += delta * step_speed
		legs[i].position.y = -step_height * sin(walking_animation_time + i)  + leg_initial_positions[i].y
		legs[i].position.x = step_size * cos(walking_animation_time + i) + leg_initial_positions[i].x


'''
var step_height = 25
var step_size = 20
var step_offset = 80
var body_offset = 30
var walking_animation_time: float = 0.0
func manage_walking_animation(delta):
	var step_speed = 10
	walking_animation_time += delta * step_speed
	if velocity.length() > 10:
		var move_dir = velocity.normalized()
		var side_dir = move_dir.orthogonal()
		
		$LeftFoot.position   = move_dir * step_size * sin(walking_animation_time) + side_dir * step_size * 0.3
		$LeftFoot.position.y -= step_height * cos(walking_animation_time) - step_offset
		
		$RightFoot.position = move_dir * step_size * sin(walking_animation_time + PI) - side_dir * step_size * 0.3
		$RightFoot.position.y -= step_height * cos(walking_animation_time + PI) - step_offset
		$Body.position.y = sin(walking_animation_time) + body_offset
	else:
		$LeftFoot.position = $LeftFoot.position.move_toward(Vector2(-step_size * 0.5, step_height), delta)
		$RightFoot.position = $RightFoot.position.move_toward(Vector2(step_size * 0.5, step_height), delta)
		$Body.position.y = sin(walking_animation_time) + body_offset'''
