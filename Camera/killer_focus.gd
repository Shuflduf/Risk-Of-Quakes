extends CameraSystem

var killer: Node3D = null

func _process(_delta: float) -> void:
	if killer:
		rotation_offset = -get_parent().get_node(^"Mouse").rotation_offset
		rotation_offset += cam.global_transform.looking_at(killer.global_position).basis.get_euler() 
		rotation_offset.y -= manager.player.rotation.y
	else:
		rotation_offset = Vector3.ZERO
