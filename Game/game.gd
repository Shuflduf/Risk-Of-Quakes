extends Node3D


func join_as(survivor: PackedScene):
	var spawn_pos = get_tree().get_nodes_in_group(&"Spawn Point").pick_random()
	var new_player = survivor.instantiate()
	new_player.position = spawn_pos.position
	add_child(new_player)
