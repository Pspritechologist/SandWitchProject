class_name GunManager extends RayCast3D

@export_group("Inputs", "input")
@export var input_weapon_primary := "weapon_primary"
@export var input_weapon_secondary := "weapon_secondary"


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed(input_weapon_primary):
		print("Primary Fire")
		force_raycast_update()
		var hm: HitboxManager = get_collider()
		if (hm):
			print(hm)
			hm.do_hit(50)
	
	if Input.is_action_just_pressed(input_weapon_secondary):
		print("Secondary Fire")
	
