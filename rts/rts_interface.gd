class_name RtsInterface extends Control

## Node to be used as the spawn position for the RtsCamera, if present.
@export var _spawn_marker: Marker3D

@onready var _unit_selector: UnitSelector = $UnitSelector
@onready var _camera: RtsCamera = $RtsCamera

func _ready() -> void:
	if _spawn_marker:
		_camera.global_transform = _spawn_marker.global_transform
		_spawn_marker.queue_free()
	
	for i in range(1, 1000):
		var data := UnitData.new()
		data.unit_name = str(i)
		data.unit_desc = "Fake unit number %d" % i
		_unit_selector.add_unit(data)
	

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(&"unit_menu"):
		_unit_selector.visible = !_unit_selector.visible
		
	

func _on_unit_selected(unit: UnitData):
	_unit_selector.remove_unit(unit.unit_name)
	

func _process(delta: float) -> void:
	_handle_selected_unit(delta)
	

func _handle_selected_unit(_delta: float) -> void:
	if !_unit_selector.is_unit_selected(): return
	
	
