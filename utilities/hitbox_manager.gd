class_name HitboxManager extends Area3D


signal hit(damage: int)

func do_hit(damage: int) -> void:
	hit.emit(damage)
