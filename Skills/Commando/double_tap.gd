extends Skill

signal used(gun_index: int)

#@export var skill_name: String
@export var guns: Array[Node3D]
@export var kick_strength_deg = 20.0
@export var kick_strength_m = 0.05
@export var hitscan: RayCast3D

var current_cooldown = 0.0
var next_gun_index = 0

@onready var og_gun_transforms: Array = guns.map(func(gun): return gun.transform)
@onready var cam: Camera3D = get_parent().cam


func use():
	if current_cooldown > 0.0:
		return
	current_cooldown = info.cooldown
	guns[next_gun_index].transform = og_gun_transforms[next_gun_index]
	var tween = get_tree().create_tween().set_ease(Tween.EASE_OUT)
	(
		tween
		. tween_property(guns[next_gun_index], ^"rotation:z", deg_to_rad(kick_strength_deg), 0.05)
		. set_trans(Tween.TRANS_EXPO)
	)
	(
		tween
		. parallel()
		. tween_property(guns[next_gun_index], ^"position:z", kick_strength_m, 0.05)
		. set_trans(Tween.TRANS_EXPO)
	)
	tween.tween_property(guns[next_gun_index], ^"rotation:z", 0.0, info.cooldown * 2.0).set_trans(
		Tween.TRANS_CUBIC
	)
	(
		tween
		. parallel()
		. tween_property(guns[next_gun_index], ^"position:z", 0.0, info.cooldown * 2.0)
		. set_trans(Tween.TRANS_CUBIC)
	)
	next_gun_index += 1
	next_gun_index %= guns.size()

	if hitscan.is_colliding():
		var new_particles: GPUParticles3D = $ImpactParticles.duplicate()
		get_tree().root.add_child(new_particles)
		new_particles.global_position = hitscan.get_collision_point()
		new_particles.quaternion = Quaternion(Vector3.UP, hitscan.get_collision_normal())
		new_particles.restart()
		new_particles.finished.connect(func(): new_particles.queue_free())

		var hitbox = hitscan.get_collider()
		if hitbox.name == &"Hitbox":
			hitbox.hit(4.0)

	used.emit(next_gun_index)
	cooldown_started.emit()


func _physics_process(delta: float) -> void:
	current_cooldown -= delta
	hitscan.global_position = cam.global_position
