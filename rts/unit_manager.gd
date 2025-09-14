class_name UnitManager extends Area3D

var data: UnitData

signal variantize
signal on_spawn
signal on_mouseover
signal on_leave
signal on_select

func get_unit_root() -> Node3D:
	return owner
	

## Spawns the provided unit under the given parent.[br]
## - [param parent]: The Node the Unit will be parented to.[br]
## - [param unit]: The unit to spawn. If the Unit's scene fails to instantiate, an error will be printed.[br]
## - [param xform]: The Transform3D to be applied to the unit after spawning it.
static func spawn_unit(parent: Node, data: UnitData, xform: Transform3D = Transform3D()) -> UnitManager:
	var unit: Node3D = data.unit_scene.instantiate()
	if !unit:
		push_error("Failed to instantiate Unit: %s (%s)" % [data.unit_name, data.unit_scene.resource_path])
		print_debug("TIP: The root of a Unit's Scene must be a Node3D")
		return null
		
	
	var manager: UnitManager = unit.get_node_or_null("%UnitManager")
	if !manager:
		push_error("Failed to get UnitManager Node from Unit: %s (%s)" % [data.unit_name, data.unit_scene.resource_path])
		print_debug("TIP: Ensure the UnitManager Node has a unique name within the Unit's Scene, and that the `owner` property is set correctly")
		return null
		
	
	manager.data = data
	
	unit.transform = xform
	parent.add_child(unit)
	
	manager.on_spawn.emit()
	manager.variantize.emit()
	
	return manager
	
