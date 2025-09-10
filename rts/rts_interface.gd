class_name RtsInterface extends Control

@export var _dbg_units: Array[UnitData]

@onready var unit_selector: UnitSelector = $UnitSelector

func _ready() -> void:
	for i in range(1, 1000):
		var data := UnitData.new()
		data.unit_name = str(i)
		data.unit_desc = "Fake unit number %d" % i
		unit_selector.add_unit(data)
	

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(&"unit_menu"):
		unit_selector.visible = !unit_selector.visible
		
	

func _on_unit_selected(unit: UnitData):
	unit_selector.remove_unit(unit.unit_name)
	

func _process(delta: float) -> void:
	_handle_selected_unit()
	

func _handle_selected_unit() -> void:
	if !unit_selector.is_unit_selected(): return
	
	
