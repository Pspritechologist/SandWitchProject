class_name RtsCursor extends MeshInstance3D

@export var follow_mouse := true

func _process(delta: float) -> void:
	if !follow_mouse: return
	Input.get_current_cursor_shape()
	
