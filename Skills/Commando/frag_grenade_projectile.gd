extends RigidBody3D

var player_owner: CharacterBody3D
var damage = 0


func _on_body_entered(_body: Object) -> void:
	linear_velocity /= 2.0


func _on_explode_timer_timeout() -> void:
	for hitbox in $ExplosionRadius.get_overlapping_areas():
		hitbox.hit(player_owner, damage)
		var vec_to_hitbox = hitbox.global_position - global_position
		var distance = vec_to_hitbox.length()
		var direction_away = vec_to_hitbox.normalized()

		var splash_radius = 120.0
		var knockback = 7.0 * (1.0 - distance / splash_radius)

		hitbox.knockback(direction_away * knockback)

	queue_free()
