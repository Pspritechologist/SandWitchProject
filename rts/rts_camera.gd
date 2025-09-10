class_name RtsCamera extends Camera3D

@export var cursor_follow_mouse := true

@onready var _raycast: RayCast3D = $RayCast3D
@onready var _cursor: Node3D = $RtsCursor

func _process(delta: float) -> void:
	if !cursor_follow_mouse: return
	
	var mouse_pos := get_viewport().get_mouse_position()
	var normal := self.project_ray_normal(mouse_pos)
	
	var facing := _raycast.global_position + normal
	_raycast.look_at(facing)
	
	_raycast.force_raycast_update()
	var hit_pos := _raycast.get_collision_point()
	_cursor.global_position = hit_pos
	
	_cursor.rotate_y(deg_to_rad(45) * delta)
	

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		var mouse_event := event as InputEventMouseMotion
		if Input.is_action_pressed(&"rotate", true):
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
			rotate_y(deg_to_rad(-mouse_event.relative.x * 0.1))
			var new_rot := rotation_degrees
			new_rot.x = clamp(new_rot.x - mouse_event.relative.y * 0.1, -89.9, 89.9)
			rotation_degrees = new_rot
		elif Input.is_action_pressed(&"pan", true):
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
			var right := -transform.basis.x.normalized()
			var forward := -transform.basis.z.normalized()
			translate_object_local(right * mouse_event.relative.x * 0.1)
			translate_object_local(forward * mouse_event.relative.y * 0.1)
	elif event.is_action_released(&"pan") or event.is_action_released(&"rotate"):
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
