class_name Ui extends Control

@export var health_bar: ProgressBar

func set_health(current: int, maximum: int) -> void:
	health_bar.value = current
	health_bar.max_value = maximum
