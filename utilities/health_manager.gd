class_name HealthManager extends Node

signal died

@export var max_health := 100
@export var health_bar: Label3D

var current_health := max_health

func _process(_delta: float) -> void:
	if health_bar:
		health_bar.text = "%d / %d" % [current_health, max_health]
	

func add_health(amount: int) -> void:
	current_health = clamp(current_health + amount, 0, max_health)
	if current_health == 0:
		died.emit()
	
