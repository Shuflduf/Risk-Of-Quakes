extends Node3D

@export var rocket_scene: PackedScene

func _unhandled_input(event: InputEvent) -> void:
	if !visible:
		return
	if event.is_action_pressed("shoot") and event.is_pressed():
		print("shoot")
		var new_rocket = rocket_scene.instantiate()
		add_child(new_rocket)
		new_rocket.global_position = global_position
		new_rocket.global_rotation = global_rotation
		
