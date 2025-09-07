extends RigidBody3D

@export var hitbox_manager: HitboxManager
@export var health_manager: HealthManager


func _ready() -> void:
	hitbox_manager.hit.connect(func(damage: int) -> void: health_manager.add_health(-damage))
	health_manager.died.connect(func() -> void:
		queue_free()
		for obj in get_colliding_bodies():
			if obj is not RigidBody3D: continue
			@warning_ignore('unsafe_property_access')
			obj.sleeping = false
	)


func _physics_process(_delta: float) -> void:
	for obj in hitbox_manager.get_overlapping_areas():
		if obj is HitboxManager:
			var hm := obj as HitboxManager
			hm.do_hit(1)
