extends Node3D

@export var shoot_cooldown = 0.3
@export var akimbos: Array[Node3D]
@export var kick_strength_deg = 20.0

var current_cooldown = 0.0
var next_gun_index = 0

@onready var hitscan: Node = get_parent().ray

func shoot():
	current_cooldown = shoot_cooldown
	akimbos[next_gun_index].rotation.z = deg_to_rad(kick_strength_deg)
	next_gun_index += 1
	next_gun_index %= akimbos.size()
	
	if hitscan.is_colliding():
		var new_particles: GPUParticles3D = $ImpactParticles.duplicate()
		add_child(new_particles)
		new_particles.global_position = hitscan.get_collision_point()
		new_particles.quaternion = Quaternion(Vector3.UP, hitscan.get_collision_normal())
		new_particles.restart()
		new_particles.finished.connect(func(): new_particles.queue_free())
		
		var hitbox = hitscan.get_collider()
		if hitbox.name == &"Hitbox":
			hitbox.hit(4.0)

func _physics_process(delta: float) -> void:
	if !visible:
		return
	current_cooldown -= delta
	if Input.is_action_pressed("primary") && current_cooldown <= 0.0:
		shoot()
	for akimbo in akimbos:
		if akimbo.rotation.z > 0:
			akimbo.rotation.z -= delta * deg_to_rad(kick_strength_deg) / (shoot_cooldown * akimbos.size())
