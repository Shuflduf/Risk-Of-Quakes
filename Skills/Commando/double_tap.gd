extends Node3D

@export var shoot_cooldown = 0.3
@export var guns: Array[Node3D]
@export var kick_strength_deg = 20.0
@export var kick_strength_m = 0.05

var current_cooldown = 0.0
var next_gun_index = 0

@onready var hitscan: RayCast3D = get_parent().ray
@onready var og_gun_transforms: Array = guns.map(func(gun): return gun.transform)

func shoot():
	current_cooldown = shoot_cooldown
	guns[next_gun_index].transform = og_gun_transforms[next_gun_index]
	var tween = get_tree().create_tween().set_ease(Tween.EASE_OUT)
	tween.tween_property(guns[next_gun_index], ^"rotation:z", deg_to_rad(kick_strength_deg), 0.05).set_trans(Tween.TRANS_EXPO)
	tween.parallel().tween_property(guns[next_gun_index], ^"position:z", kick_strength_m, 0.05).set_trans(Tween.TRANS_EXPO)
	tween.tween_property(guns[next_gun_index], ^"rotation:z", 0.0, shoot_cooldown * 2.0).set_trans(Tween.TRANS_CUBIC)
	tween.parallel().tween_property(guns[next_gun_index], ^"position:z", 0.0, shoot_cooldown * 2.0).set_trans(Tween.TRANS_CUBIC)
	next_gun_index += 1
	next_gun_index %= guns.size()
	
	if hitscan.is_colliding():
		var new_particles: GPUParticles3D = $ImpactParticles.duplicate()
		add_child(new_particles)
		new_particles.global_position = hitscan.get_collision_point()
		new_particles.quaternion = Quaternion(Vector3.UP, hitscan.get_collision_normal())
		new_particles.restart()
		new_particles.finished.connect(func(): new_particles.queue_free())
		
		var hitbox = hitscan.get_collider()
		print(hitbox)
		if hitbox.name == &"Hitbox":
			hitbox.hit(4.0)

func _physics_process(delta: float) -> void:
	if !visible:
		return
	current_cooldown -= delta
	if Input.is_action_pressed("primary") && current_cooldown <= 0.0:
		shoot()
