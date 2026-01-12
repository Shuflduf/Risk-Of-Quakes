extends Skill

signal used(started: bool)

@export var phase_round_projectile: PackedScene
@export var double_tap: Node3D

var current_cooldown = 0.0
var hold_duration = 0.0

@onready var player: CharacterBody3D = get_parent().player
@onready var cam: Camera3D = get_parent().cam

var held_down = false
var use_called_this_frame = false

func _physics_process(delta: float) -> void:
	current_cooldown -= delta
	
	if held_down && !use_called_this_frame: 
		held_down = false
		release()
	
	use_called_this_frame = false
	
	if held_down:
		hold_duration += delta

func use():
	if current_cooldown > 0.0:
		return
	
	use_called_this_frame = true
	
	if !held_down:
		hold()
		held_down = true
		double_tap.current_cooldown = INF

func hold():
	print("FUCK")
	used.emit(true)
	for i in double_tap.guns.size():
		var gun: Node3D = double_tap.guns[i]
		var right_side = i % 2 == 0
		var side_mult = -1.0 if right_side else 1.0
		#gun.position.x = 0.2 * side_mult

		var tween = get_tree().create_tween().set_ease(Tween.EASE_OUT)
		tween.tween_property(gun, ^"position:x", 0.2 * side_mult, 0.4).set_trans(Tween.TRANS_BACK)
		tween.parallel().tween_property(gun, ^"position:y", i * 0.1, 0.4).set_trans(Tween.TRANS_BACK)
		tween.parallel().tween_property(gun, ^"rotation:x", (-PI * side_mult) / 2.5, 0.2).set_trans(Tween.TRANS_EXPO)


func release():
	current_cooldown = info.cooldown
	
	var new_projectile: Node3D = phase_round_projectile.instantiate()
	get_tree().root.add_child(new_projectile)
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

	double_tap.current_cooldown = 0.0
	used.emit(false)
