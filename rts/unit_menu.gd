class_name UnitSelector extends Control

signal unit_selected(unit: UnitData)

const UNIT_BOX := preload("res://rts/unit_box.tscn")

@onready var scroll: ScrollContainer = $ScrollContainer
@onready var grid: GridContainer = $ScrollContainer/GridContainer

var selected_unit: UnitData

var _units: Dictionary[String, UnitBox]

func is_unit_selected() -> bool: return selected_unit != null

func add_unit(unit: UnitData) -> void:
	if _units.has(unit.unit_name): return
	
	var box: UnitBox = UNIT_BOX.instantiate()
	box.on_pressed.connect(func(unit) -> void: unit_selected.emit(unit))
	
	grid.add_child(box)
	_units.set(unit.unit_name, box)
	box.unit = unit
	

func remove_unit(unit_name: StringName) -> void:
	var box := _units[unit_name]
	if !box: return
	_units.erase(unit_name)
	box.queue_free()
	

func select_unit(unit_name: StringName) -> void:
	pass
	

func deselect_unit() -> void:
	pass
	

func _ready() -> void:
	scroll.resized.connect(func() -> void:
		grid.columns = floori(scroll.size.x / 100)
		grid.add_theme_constant_override("h_separation", int(fmod(scroll.size.x, 100) / grid.columns))
	)
	
