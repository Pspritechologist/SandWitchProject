class_name RtsInterface extends Control

@export var _debug_units: Array[UnitData]

## Node to be used as the spawn position for the RtsCamera, if present.
@export var _spawn_marker: Marker3D

@onready var _unit_selector: UnitSelector = $UnitSelector
@onready var _camera: RtsCamera = $RtsCamera

func _ready() -> void:
	if _spawn_marker:
		_camera.set_cam_global_transform(_spawn_marker.global_transform)
		_spawn_marker.queue_free()
	
	for data in _debug_units:
		#var data := UnitData.new()
		#data.unit_name = str(i)
		#data.unit_desc = "Fake unit number %d" % i
		#data.unit_scene = preload("res://rts/units/unit_charlie.tscn")
		_unit_selector.add_unit(data)
	

func _input(event: InputEvent) -> void:
	if event.is_action_pressed(&"unit_menu"):
		_unit_selector.visible = !_unit_selector.visible
	elif event.is_action_pressed(&"right"):
		var unit := _camera.get_unit_at_cursor()
		if unit: unit.get_unit_root().queue_free()
		
	

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(&"spawn_unit"): if _unit_selector.is_unit_selected():
		_camera.spawn_unit(get_parent(), _unit_selector.selected_unit)
	

func _on_unit_selected(unit: UnitData):
	_camera.set_cursor_color(Color.RED if unit else Color.AQUA)
	
