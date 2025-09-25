extends "./character_temp.gd"

@onready var float_area := %FloatArea
@onready var stand_area := %StandArea

func _apply_gravity(delta: float) -> void:
	if float_area.has_overlapping_bodies():
		velocity.y = 3
	elif _check_on_floor():
		if velocity.y < 0: velocity.y = move_toward(velocity.y, 0, 2)
	else:
		velocity += get_gravity() * delta
	

func _check_on_floor() -> bool:
	return is_on_floor() or stand_area.has_overlapping_bodies() or float_area.has_overlapping_bodies()
	
