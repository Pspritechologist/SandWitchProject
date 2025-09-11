class_name RtsCamera extends Camera3D

@export var do_follow_mouse := true

var _do_follow_mouse := true

@onready var _raycast: RayCast3D = $RayCast3D
@onready var _cursor: MeshInstance3D = $RtsCursor

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
	

func _process(delta: float) -> void:
	if _do_follow_mouse && do_follow_mouse:
		var mouse_pos := get_viewport().get_mouse_position()
		
		_raycast.global_position = self.project_ray_origin(mouse_pos)
		
		var hit_pos := _raycast.get_collision_point()
		_cursor.global_position = hit_pos
	
	_cursor.rotate_y(deg_to_rad(45) * delta)
	

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		var mouse_event := event as InputEventMouseMotion
		if Input.is_action_pressed(&"pan", true):
			#Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
			#_do_follow_mouse = false
			translate(-transform.basis.x * mouse_event.relative.x * 0.1)
			translate(transform.basis.z * mouse_event.relative.y * 0.1)
	elif event.is_action_released(&"pan"): pass
			#Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			#var curs_pos := _cursor.global_transform.origin
			#Input.warp_mouse(self.unproject_position(curs_pos))
			#_do_follow_mouse = true
	
