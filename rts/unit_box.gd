class_name UnitBox extends MarginContainer

signal on_pressed(data: UnitData)

@onready var btn: Button = $Button

var unit: UnitData:
	set(new_unit):
		unit = new_unit
		var nam: String = unit.unit_name
		btn.text = unit.unit_name
		btn.tooltip_text = unit.unit_desc
		

func set_unit(new_unit: UnitData) -> void: unit = new_unit

func _on_pressed() -> void:
	on_pressed.emit(unit)
	
