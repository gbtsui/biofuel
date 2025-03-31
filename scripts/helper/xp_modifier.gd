extends Resource
class_name XPModifier

static func get_scalar(xp_type, xp_amount) -> float:
	match xp_type:
		"knockback_magnitude":
			return 1 + (floor(sqrt(xp_amount / 10)) / 10)
		_:
			return 1 + floor(sqrt(xp_amount / 10)) / 5 # arbitrary constants

static func get_level(xp_type, xp_amount):
	match xp_type:
		_:
			return floor(sqrt(xp_amount / 10))

static func get_xp_to_next_level(xp_type, xp_amount):
	var level = get_level(xp_type, xp_amount)
	var next_level_xp = pow(ceil(level + 1.0), 2) * 10
	return ceil(next_level_xp - xp_amount)
