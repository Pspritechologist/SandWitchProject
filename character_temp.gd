extends CharacterBody3D

@export var speed := 5.0
@export var jump_velocity := 4.5

@export_subgroup("Inputs", "input")
@export var input_mouse_sensitivity := 100
@export var input_move_foward := "fowards"
@export var input_move_backward := "backwards"
@export var input_move_left := "left"
@export var input_move_right := "right"
@export var input_jump := "jump"

@onready var head: Node3D = %Head
@onready var camera: Camera3D = %Camera

func _physics_process(delta: float) -> void:
	velocity += get_gravity() * delta
	
	# Handle input_jump.
	if Input.is_action_just_pressed(input_jump) and is_on_floor():
		velocity.y = jump_velocity
		
	
	var input_dir := Input.get_vector(input_move_left, input_move_right, input_move_foward, input_move_backward)
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)
	
	if Input.is_action_just_pressed("pause"):
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		else:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	move_and_slide()
	

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		var mouse_event := event as InputEventMouseMotion
		var motion := mouse_event.relative * (0.001 * input_mouse_sensitivity)
		rotate_y(-deg_to_rad(motion.x))
		head.rotate_x(-deg_to_rad(motion.y))
		head.rotation.x = clamp(head.rotation.x, deg_to_rad(-89), deg_to_rad(89))
	
