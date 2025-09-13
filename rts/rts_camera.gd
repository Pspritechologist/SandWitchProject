class_name RtsCamera extends Node3D

@export var do_follow_mouse := true

var _do_follow_mouse := true

@onready var _raycast: RayCast3D = $Camera3D/RayCast3D
@onready var _cursor: MeshInstance3D = $RtsCursor
@onready var _cursor_select: Area3D = $RtsCursor/CursorSelectionBounds
@onready var _cam: Camera3D = $Camera3D
@onready var _target_rot := self.global_rotation.y
@onready var _target_size := _cam.size

## Spawns a unit at the cursor's location.
## - [arg parent]: The Node the Unit will be parented to.
## - [arg unit]: The unit to spawn. If the Unit's scene fails to instantiate, an error will be printed.
## - [arg rotate]: Should the unit be rotated so it faces away from the camera.
## - [arg offset]: An optional offset applied to the unit after after spawning it.
## - [arg rot_offset]: An optional offset as a [Basis] applied to the Unit after spawning it.
##   The Unit's rotation will be multiplied by the provided Basis after spawning.
func spawn_unit(parent: Node, unit: UnitData, rotate: bool = true, offset: Vector3 = Vector3(), rot_offset: Basis = Basis()) -> void:
	var unit_inst: Node3D = unit.unit_scene.instantiate()
	if !unit_inst:
		push_error("Failed to instantiate Unit: %s (%s)" % [unit.unit_name, unit.unit_scene.resource_path])
		print_debug("A the root of a Unit's Scene must be a Node3D")
		return
		
	
	parent.add_child(unit_inst)
	
	unit_inst.global_position = _cursor.global_position
	if rotate:
		var cam := self.global_position
		var curs := _cursor.global_position
		cam.y = 0
		curs.y = 0
		var diff := cam - curs
		unit_inst.look_at(diff * 100)
		
	
	unit_inst.position += offset
	unit_inst.rotation *= rot_offset
	

func set_cursor_color(color: Color) -> void:
	_cursor.mesh.surface_get_material(0).albedo_color = color
	

func set_cam_global_transform(new: Transform3D):
	global_transform = new
	_target_rot = global_rotation.y
	

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
	
