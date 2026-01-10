extends Node

@export var phase_round_projectile: PackedScene
@export var double_tap: Node3D
@export var use_cooldown = 1.0

var current_cooldown = 0.0
var hold_duration = 0.0

@onready var player: CharacterBody3D = get_parent().player
@onready var cam: Camera3D = get_parent().cam

func _physics_process(delta: float) -> void:
	current_cooldown -= delta
	if Input.is_action_just_pressed(&"secondary") and current_cooldown <= 0.0:
		hold_duration += delta
		double_tap.current_cooldown = INF
		for i in double_tap.guns.size():
			var gun: Node3D = double_tap.guns[i]
			var left_side = i % 2 == 0
			var side_mult = 1.0 if left_side else -1.0
			#gun.position.x = 0.2 * side_mult

			var tween = get_tree().create_tween().set_ease(Tween.EASE_OUT)
			tween.tween_property(gun, ^"position:x", 0.2 * side_mult, 0.4).set_trans(Tween.TRANS_BACK)
			tween.parallel().tween_property(gun, ^"position:y", i * 0.1, 0.4).set_trans(Tween.TRANS_BACK)
			tween.parallel().tween_property(gun, ^"rotation:x", (-PI * side_mult) / 2.5, 0.2).set_trans(Tween.TRANS_EXPO)
	
	if Input.is_action_just_released(&"secondary") and hold_duration > 0.0:
		current_cooldown = use_cooldown
		
		var new_projectile: Node3D = phase_round_projectile.instantiate()
		add_child(new_projectile)
		new_projectile.global_rotation = cam.global_rotation
		new_projectile.global_position = cam.global_position
		new_projectile.speed = clamp(hold_duration, 1.0, 3.0) * 15.0
		new_projectile.player_owner = player
		hold_duration = 0.0
		
		#await get_tree().create_timer(0.1).timeout
		for i in double_tap.guns.size():
			var gun: Node3D = double_tap.guns[i]
			var tween = get_tree().create_tween().set_ease(Tween.EASE_OUT)
			tween.tween_property(gun, ^"rotation:z", deg_to_rad(20.0), 0.1).set_trans(Tween.TRANS_EXPO)
			#tween.tween_property(gun, ^"rotation:z", 0.0, 0.2).set_trans(Tween.TRANS_CUBIC)
			#tween.tween_interval(0.1)
			tween.tween_property(gun, ^"transform", double_tap.og_gun_transforms[i], 0.3).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
			#gun.rotation.z = deg_to_rad(20.0)
		
		#await get_tree().create_timer(0.5).timeout
		#for i in double_tap.guns.size():
			#var gun: Node3D = double_tap.guns[i]
			#gun.transform = double_tap.og_gun_transforms[i]
			
		double_tap.current_cooldown = 0.0
			#gun.rotate_object_local(Vector3.UP, deg_to_rad(10.0))
