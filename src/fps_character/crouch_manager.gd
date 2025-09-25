class_name CrouchManager extends Node

@export var crouch_speed_mult := 2.5

@export_group("Inputs", "input")
@export var input_crouch := "crouch"

@export var lower_collision: CollisionShape3D
@export var lower_mesh: MeshInstance3D
@export var cast: ShapeCast3D

const CROUCH_LOWER_Y = -0.25
const UNCROUCH_LOWER_Y = -0.75

var crouching := false
var actually_crouching := false


func _physics_process(delta: float) -> void:
	if crouching:
		lower_collision.position.y = move_toward(lower_collision.position.y, CROUCH_LOWER_Y, delta * crouch_speed_mult)
		actually_crouching = true
	elif not crouching and is_space_above():
		lower_collision.position.y = move_toward(lower_collision.position.y, UNCROUCH_LOWER_Y, delta * crouch_speed_mult)
		actually_crouching = false

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action(input_crouch):
		if event.is_pressed():
			crouching = true
		else:
			crouching = false

func is_space_above() -> bool:
	return not cast.is_colliding()
