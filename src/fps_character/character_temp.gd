extends CharacterBody3DExtension

@export var accel := 25.0
@export var max_speed := 5.0
@export var sprint_accel_mult := 1.5
@export var sprint_max_speed_mult := 1.5
@export var jump_velocity := 4.5
@export var jump_sprint_velocity_mult := 1.5
@export var jump_speed_boost := 2.0
@export var jump_sprint_speed_boost := 2.0
@export var air_control := 0.1

@export_group("Inputs", "input")
@export var input_mouse_sensitivity := 100
@export var input_controller_sensitivity_x := 150
@export var input_controller_sensitivity_y := 150
@export var input_move_forward := "forwards"
@export var input_move_backward := "backwards"
@export var input_move_left := "left"
@export var input_move_right := "right"
@export var input_look_up := "look_up"
@export var input_look_down := "look_down"
@export var input_look_left := "look_left"
@export var input_look_right := "look_right"
@export var input_jump := "jump"
@export var input_sprint := "sprint"
@export var input_pause := "pause"

@export var crouch_manager: CrouchManager
@export var hitbox_manager: HitboxManager
@export var health_manager: HealthManager

@export var ui: Ui

@onready var head: Node3D = %Head
@onready var camera: Camera3D = %Camera


func _ready() -> void:
	if ui: ui.set_health(health_manager.current_health, health_manager.max_health)
	
	hitbox_manager.hit.connect(func(damage: int) -> void:
		health_manager.add_health(-damage)
		if ui: ui.set_health(health_manager.current_health, health_manager.max_health)
	)
	health_manager.died.connect(func() -> void: get_tree().quit())
	

func _process(delta: float) -> void:
	var look_dir := Input.get_vector(input_look_left, input_look_right, input_look_up, input_look_down)
	rotate_y(-look_dir.x * (0.01 * input_controller_sensitivity_y) * delta)
	head.rotate_x(-look_dir.y * (0.01 * input_controller_sensitivity_x) * delta)
	

func _physics_process(delta: float) -> void:
	_apply_gravity(delta)
	
	var on_floor := _check_on_floor()
	
	var input_dir := Input.get_vector(input_move_left, input_move_right, input_move_forward, input_move_backward)
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	var is_sprinting := Input.is_action_pressed(input_sprint) and not (crouch_manager and crouch_manager.actually_crouching)
	var real_accel := (accel * sprint_accel_mult if is_sprinting else accel) * (1.0 if on_floor else air_control) * delta
	var real_max_speed := max_speed * sprint_max_speed_mult if is_sprinting else max_speed
	
	if Input.is_action_just_pressed(input_jump) and on_floor:
		velocity.y = jump_velocity * (jump_sprint_velocity_mult if is_sprinting else 1.0)
		velocity.x += direction.x * jump_speed_boost * (jump_sprint_speed_boost if is_sprinting else 1.0)
		velocity.z += direction.z * jump_speed_boost * (jump_sprint_speed_boost if is_sprinting else 1.0)
	
	if direction:
		target_speed = real_max_speed
		direction *= real_max_speed
		direction.y = velocity.y
		velocity = velocity.move_toward(direction, real_accel)
	else:
		target_speed = 0
		velocity = velocity.move_toward(Vector3(0, velocity.y, 0), real_accel)
	
	move_and_slide(delta)
	

func _unhandled_input(event: InputEvent) -> void:
	# Mouse movement.
	if event is InputEventMouseMotion:
		var mouse_event := event as InputEventMouseMotion
		var motion := mouse_event.relative * (0.001 * input_mouse_sensitivity)
		rotate_y(-deg_to_rad(motion.x))
		head.rotate_x(-deg_to_rad(motion.y))
		head.rotation.x = clamp(head.rotation.x, deg_to_rad(-89), deg_to_rad(89))
	# Cursor capturing.
	elif event.is_action_pressed(input_pause):
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		else:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		
	

func _apply_gravity(delta: float) -> void:
	velocity += get_gravity() * delta
	

func _check_on_floor() -> bool:
	return is_on_floor()
	
