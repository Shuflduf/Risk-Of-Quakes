extends RigidBody3D


func _on_body_entered(_body: Object) -> void:
	linear_velocity /= 2.0


func _on_explode_timer_timeout() -> void:
	for hitbox in $ExplosionRadius.get_overlapping_areas():
		hitbox.hit(10.0)
		var vec_to_hitbox = hitbox.global_position - global_position
		var distance = vec_to_hitbox.length()
		var direction_away = vec_to_hitbox.normalized()

		var splash_radius = 120.0
		var damage = 5.0 * (1.0 - distance / splash_radius)

		var knockback = min(damage, 200.0)

		hitbox.knockback(direction_away * knockback)

	queue_free()
