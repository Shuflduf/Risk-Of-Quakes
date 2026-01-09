extends RigidBody3D


func _on_body_entered(body: Object) -> void:
	print(body)
	#if body is CollisionObject3D:
		#if body.get_collision_layer_value(0):
	#physics_material_override.bounce = 0.0
	linear_velocity /= 2.0
