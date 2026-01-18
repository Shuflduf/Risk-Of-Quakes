extends Node3D

@export var rocket_speed = 30.0

@onready var explode_particles: GPUParticles3D = $ExplodeParticles
@onready var blast_radius: Area3D = $BlastRadius

var explosion_queued = false


func _physics_process(delta: float) -> void:
	if explosion_queued:
		return
	transform = transform.translated_local(Vector3.FORWARD * delta * rocket_speed)


func _on_area_3d_body_entered(_body: Node3D) -> void:
	if explosion_queued:
		return
	$CSGBox3D.hide()
	explosion_queued = true
	explode_particles.restart()

	for body in blast_radius.get_overlapping_bodies():
		var rocket_jump_node = body.get_node(^"RocketJump")
		if rocket_jump_node:
			var vec_to_body = body.global_position - global_position
			var distance = vec_to_body.length()
			var direction_away = vec_to_body.normalized()

			var splash_radius = 120.0
			var damage = 5.0 * (1.0 - distance / splash_radius)

			var knockback = min(damage, 200.0)

			rocket_jump_node.jump(direction_away * knockback)

	await explode_particles.finished
	queue_free()
