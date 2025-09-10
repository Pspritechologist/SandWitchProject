class_name UnitSelector extends Control

## A signal that fires whenever a unit is selected,
## typically by button press but also manually.[br]
## [code]unit[/code] will be [code]null[/code] if a Unit was instead deselected.
signal unit_selected(unit: UnitData)

var selected_unit: UnitData

@export var _unit_box := preload("res://rts/unit_box.tscn")

@onready var _scroll: ScrollContainer = $ScrollContainer
@onready var _grid: GridContainer = $ScrollContainer/GridContainer

var _units: Dictionary[String, UnitBox]

func is_unit_selected() -> bool: return selected_unit != null

func add_unit(unit: UnitData) -> void:
	if _units.has(unit.unit_name): return
	
	var box: UnitBox = _unit_box.instantiate()
	box.on_pressed.connect(_on_unit_selected)
	
	_grid.add_child(box)
	_units.set(unit.unit_name, box)
	box.unit = unit
	

func remove_unit(unit_name: StringName) -> void:
	var box := _units[unit_name]
	if !box: return
	_units.erase(unit_name)
	box.queue_free()
	

func select_unit(unit_name: StringName) -> void:
	var btn := _units[unit_name]
	if !btn:
		push_warning("Tried to select unknown Unit: '%s'" % unit_name)
		return
	#_scroll.ensure_control_visible(btn)
	btn.grab_focus()
	_on_unit_selected(btn.unit)
	

func deselect_unit() -> void:
	_on_unit_selected(null)
	

func _ready() -> void:
	_scroll.resized.connect(func() -> void:
		_grid.columns = floori(_scroll.size.x / 100)
		_grid.add_theme_constant_override("h_separation", int(fmod(_scroll.size.x, 100) / _grid.columns))
	)
	

func _on_unit_selected(unit: UnitData) -> void:
	selected_unit = unit
	unit_selected.emit(unit)
	
