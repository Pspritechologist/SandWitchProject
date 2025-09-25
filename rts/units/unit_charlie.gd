extends "res://rts/units/unit_humanoid_base.gd"

@export var _outline: ShaderMaterial

@onready var _nav: NavigationAgent3D = $NavigationAgent3D
@onready var _speech: Label3D = $Speech

var _dying := false

func _on_hover() -> void:
	if _dying: return
	_speech.text = ["Hiya!", "Howdy", "owo", "hi!", "uh, hi", "Oh, hello", "*waves*"].pick_random()
	_speech.visible = true
	$Body/Mesh.get_surface_override_material(0).next_pass = _outline
	

func _on_leave() -> void:
	if _dying: return
	_speech.visible = false
	$Body/Mesh.get_surface_override_material(0).next_pass = null
	

func _on_death() -> void:
	_speech.text = "AAGGHH"
	_speech.visible = true
	_dying = true
	await get_tree().create_timer(1.5).timeout
	super()
	

func _on_hit(damage: int) -> void:
	if _dying: return
	super(damage)
	

func _physics_process(delta: float) -> void:
	_nav.target_position = Globals.get_player_xform().origin
	var next_pos := _nav.get_next_path_position()
	look_at(Vector3(next_pos.x, self.global_position.y, next_pos.z), Vector3.UP)
	self.velocity = (next_pos - global_position).normalized() * 3.0
	super(delta)
	
