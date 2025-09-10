extends CharacterBody3D

@export var _hitbox_manager: HitboxManager
@export var _health_manager: HealthManager

func _ready() -> void:
	_hitbox_manager.hit.connect(_on_hit)
	_health_manager.died.connect(_on_death)
	

func _physics_process(delta: float) -> void:
	if not is_on_floor(): velocity += get_gravity() * delta
	move_and_slide()
	

func _on_hit(damage: int) -> void:
	_health_manager.add_health(-damage)
	

func _on_death() -> void:
	queue_free()
	
