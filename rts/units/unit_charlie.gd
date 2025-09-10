extends "res://rts/units/unit_humanoid_base.gd"

var _dying := false

func _on_death() -> void:
	$Speech.visible = true
	_dying = true
	await get_tree().create_timer(1.5).timeout
	super()
	

func _on_hit(damage: int) -> void:
	if _dying: return
	super(damage)
	
