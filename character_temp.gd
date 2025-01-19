extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

@export_category("Inputs")
@export var mouse_sensitivity: float = 100
@export var move_foward: String = "fowards"
@export var move_backward: String = "backwards"
@export var move_left: String = "left"
@export var move_right: String = "right"
@export var jump: String = "jump"

@onready var head: Node3D = %Head
@onready var camera: Camera3D = %Camera

func _physics_process(delta: float) -> void:
	velocity += get_gravity() * delta
	
	# Handle jump.
	if Input.is_action_just_pressed(jump) and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	
	var input_dir := Input.get_vector(move_left, move_right, move_foward, move_backward)
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	
	move_and_slide()
	

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		event = event as InputEventMouseMotion
		var motion = event.relative * (0.001 * mouse_sensitivity)
		rotate_y(-deg_to_rad(motion.x))
		head.rotate_x(-deg_to_rad(motion.y))
		head.rotation.x = clamp(head.rotation.x, deg_to_rad(-89), deg_to_rad(89))
	
