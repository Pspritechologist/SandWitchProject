class_name RtsCamera extends Node3D

@export var do_follow_mouse := true

var _do_follow_mouse := true

@onready var _raycast: RayCast3D = $Camera3D/RayCast3D
@onready var _cursor: MeshInstance3D = $RtsCursor
@onready var _cursor_select: Area3D = $RtsCursor/CursorSelectionBounds
@onready var _cam: Camera3D = $Camera3D
@onready var _target_rot := self.global_rotation.y
@onready var _target_size := _cam.size

## Spawns a unit at the cursor's location.[br]
## - [param parent]: The Node the Unit will be parented to.[br]
## - [param unit]: The unit to spawn. If the Unit's scene fails to instantiate, an error will be printed.[br]
## - [param rotate]: Should the unit be rotated so it faces away from the camera.[br]
## - [param offset]: An optional offset applied to the unit after after spawning it.[br]
## - [param rot_offset]: An optional offset as a [Basis] applied to the Unit after spawning it.
##   The Unit's rotation will be multiplied by the provided Basis after spawning.
func spawn_unit(parent: Node, data: UnitData, rotate: bool = true, offset: Vector3 = Vector3(), rot_offset: Basis = Basis()) -> void:
	var xform := Transform3D()
	xform.origin = _cursor.global_position + offset
	
	# if rotate:
	# 	var dir_to_cam := (self.global_position - xform.origin).normalized()
	# 	var look_at := Vector3(dir_to_cam.x, 0, dir_to_cam.z).normalized()
	# 	var up := Vector3.UP
	# 	var right := up.cross(look_at).normalized()
	# 	look_at = right.cross(up).normalized()
	
	xform.basis *= rot_offset
	
	return UnitManager.spawn_unit(parent, data, xform)
	

func set_cursor_color(color: Color) -> void:
	_cursor.mesh.surface_get_material(0).albedo_color = color
	

func get_unit_at_cursor() -> UnitManager:
	return _cursor_select.get_overlapping_areas().pop_back() as UnitManager
	

func set_cam_global_transform(new: Transform3D):
	global_transform = new
	_target_rot = global_rotation.y
	

func _on_hover_unit_start(unit_man: UnitManager):
	unit_man.on_mouseover.emit()
	

func _on_hover_unit_stop(unit_man: UnitManager):
	unit_man.on_leave.emit()
	

func _process(delta: float) -> void:
	if _do_follow_mouse && do_follow_mouse:
		var mouse_pos := get_viewport().get_mouse_position()
		
		self._raycast.global_position = _cam.project_ray_origin(mouse_pos)
		
		var hit_pos := _raycast.get_collision_point()
		_cursor.global_position = hit_pos
	
	_cursor.rotate_y(deg_to_rad(45) * delta)
	

func _physics_process(_delta: float) -> void:
	# Handle lerping rotation here, cheap way to lock the speed.
	var lerped := lerp_angle(self.global_rotation.y, self._target_rot, 0.1)
	# If we've stopped moving, reduce the target rotation. This stops the number from growing forever.
	if snappedf(lerped, 0.01) == snappedf(self.global_rotation.y, 0.01): _target_rot = fmod(_target_rot, deg_to_rad(360))
	self.global_rotation.y = lerped
	
	_cam.size = lerpf(_cam.size, _target_size, 0.1)
	

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		var mouse_event := event as InputEventMouseMotion
		if Input.is_action_pressed(&"pan", true):
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
			_cursor.visible = false
			self.global_translate(-self.global_transform.basis.x * mouse_event.relative.x * 0.1)
			self.global_translate(-self.global_transform.basis.z * mouse_event.relative.y * 0.1)
	elif event.is_action_released(&"pan"):
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			_cursor.visible = true
	elif event.is_action_pressed(&"zoom_in", true): _target_size = clampf(_target_size - 2, 5, 30)
	elif event.is_action_pressed(&"zoom_out", true): _target_size = clampf(_target_size + 2, 5, 30)
	elif event.is_action_pressed(&"rotate_cw", true): self._target_rot -= deg_to_rad(45)
	elif event.is_action_pressed(&"rotate_ccw", true): self._target_rot += deg_to_rad(45)
	
