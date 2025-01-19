@tool
extends RigidBody3D

@export var func_godot_properties: Dictionary = {
	"mass": 5,
	"mass_max": 9,
	"friction": 0.55,
	"friction_max": 0.7,
	"bounce": 0.05,
	"bounce_max": 0.22,
	"initial_velocity": Vector3.ZERO
}

@onready var label: Label3D = $Label3D

func _process(_delta: float) -> void:
	label.global_position = global_position + Vector3.UP * 1.2
	if Engine.is_editor_hint(): return
	label.text = "Vel: %s\nMass: %s\nFriction: %s\nBounce: %s" % [
		snappedf(linear_velocity.length(), 0.01),
		snappedf(mass, 0.001),
		snappedf(physics_material_override.friction, 0.001),
		snappedf(physics_material_override.bounce, 0.001)
	]
	

func _init() -> void:
	if Engine.is_editor_hint(): return
	
	mass = randf_range(func_godot_properties["mass"], func_godot_properties["mass_max"])
	
	var phys := PhysicsMaterial.new()
	phys.friction = randf_range(func_godot_properties["friction"], func_godot_properties["friction_max"])
	phys.bounce = randf_range(func_godot_properties["bounce"], func_godot_properties["bounce_max"])
	physics_material_override = phys
	
	linear_velocity = func_godot_properties["initial_velocity"]
	
