extends Skill

signal revert_abilities
signal used(caught: bool, boosted: bool)

const BOOST_CLEAVERS = 48
const BOOST_CLEAVERS_PER_ROW = 16

@export var projectile: PackedScene
@export var throw_dist = 10.0
@export var cleaver_count = 3

var current_cooldown = 0.0
var active_cleavers: Array[Node3D]
var boosted = false

@onready var player: CharacterBody3D = get_parent().player
@onready var cam: Camera3D = get_parent().cam
@onready var model: Node3D = $Model

#@onready var model_rot = model.rotation.x


func use():
	for cleaver in active_cleavers:
		cleaver.stay()

	if current_cooldown > 0.0:
		return

	if boosted:
		revert_abilities.emit()
		for i in BOOST_CLEAVERS:
			var new_cleaver = add_cleaver(
				cam.global_position + (get_boost_target_dir(i) * throw_dist)
			)
			new_cleaver.from_boost = true
		used.emit(false, true)

	if active_cleavers.size() < cleaver_count:
		add_cleaver(cam.global_position + (-cam.global_transform.basis.z * throw_dist))
		used.emit(false, false)

		model.position.z = 0.5
		model.rotation.x = deg_to_rad(50.0)
		var tween = get_tree().create_tween()

		#tween.tween_method(model.rotat)
		tween.tween_property(model, ^"position:z", 0.0, 0.4).set_ease(Tween.EASE_OUT).set_trans(
			Tween.TRANS_BACK
		)
		(
			tween
			. parallel()
			. tween_property(model, ^"rotation:x", 0.0, 0.4)
			. set_ease(Tween.EASE_OUT)
			. set_trans(Tween.TRANS_BACK)
		)

		current_cooldown = info.cooldown


func add_cleaver(target_pos: Vector3) -> Node3D:
	var new_cleaver: Node3D = projectile.instantiate()
	active_cleavers.append(new_cleaver)
	new_cleaver.target_position = target_pos
	new_cleaver.player_owner = player
	new_cleaver.go_back_target = cam
	new_cleaver.delete.connect(
		func():
			active_cleavers.erase(new_cleaver)
			used.emit(true, new_cleaver.from_boost)
	)
	get_tree().root.add_child(new_cleaver)
	new_cleaver.global_position = cam.global_position
	return new_cleaver


func get_boost_target_dir(index: int) -> Vector3:
	const HORIZ_DIFF = PI / 8.0
	const VERT_DIFF = PI / 6.0

	var horiz_angle = HORIZ_DIFF * index + player.rotation.y

	@warning_ignore("integer_division")
	var current_row = index / BOOST_CLEAVERS_PER_ROW
	var vert_angle = VERT_DIFF * current_row
	var horiz_scale = cos(vert_angle)
	var target_dir = Vector3(
		sin(horiz_angle) * horiz_scale, sin(vert_angle), cos(horiz_angle) * horiz_scale
	)
	return target_dir


func _physics_process(delta: float) -> void:
	current_cooldown -= delta
	self.visible = active_cleavers.size() < cleaver_count
