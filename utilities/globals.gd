extends Node

func get_player_xform() -> Transform3D:
	var player: CharacterBody3D = get_tree().get_first_node_in_group(&"player")
	return player.global_transform
	

func get_player_parent() -> Node3D:
	var player: CharacterBody3D = get_tree().get_first_node_in_group(&"player")
	return player.get_parent_node_3d()
	
