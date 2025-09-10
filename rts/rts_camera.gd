class_name RtsCursor extends Camera3D

@export var cursor_follow_mouse := true

@onready var raycast: RayCast3D = $RayCast3D
@onready var cube: Node3D = $Cube

func _process(delta: float) -> void:
	if !cursor_follow_mouse: return
	
	var mouse_pos := get_viewport().get_mouse_position()
	#var origin := self.project_ray_origin(mouse_pos)
	var normal := self.project_ray_normal(mouse_pos)
	var origin := self.project_ray_origin(mouse_pos)
	var pos := self.project_position(mouse_pos, 0.1)
	
	if fmod(Engine.get_process_frames(), 120) == 0:
		print("normal: ", normal)
		print("origin: ", origin)
		print("pos   : ", pos)
	
	#cube.global_position = pos
	cube.look_at(normal)
	raycast.look_at_from_position(pos, normal)
	

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
	
