extends "res://rts/units/unit_humanoid_base.gd"

@export var _outline: ShaderMaterial

@onready var _nav: NavigationAgent3D = $NavigationAgent3D

var _dying := false

func _on_hover() -> void:
	if _dying: return
	$Speech.text = ["Hiya!", "Howdy", "owo", "hi!", "uh, hi", "Oh, hello", "*waves*"].pick_random()
	$Speech.visible = true
	$Body/Mesh.get_surface_override_material(0).next_pass = _outline
	

func _on_leave() -> void:
	if _dying: return
	$Speech.visible = false
	$Body/Mesh.get_surface_override_material(0).next_pass = null
	

func _on_death() -> void:
	$Speech.text = "AAGGHH"
	$Speech.visible = true
	_dying = true
	await get_tree().create_timer(1.5).timeout
	super()
	

func _on_hit(damage: int) -> void:
	if _dying: return
	super(damage)
	

func _physics_process(delta: float) -> void:
	super(delta)
	
