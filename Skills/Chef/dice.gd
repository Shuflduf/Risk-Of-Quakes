extends Skill

@export var projectile: PackedScene
@export var throw_dist = 10.0
@export var cleaver_count = 3

var current_cooldown = 0.0
var active_cleavers: Array[Node3D]

@onready var player: CharacterBody3D = get_parent().player
@onready var cam: Camera3D = get_parent().cam
@onready var model: Node3D = $Model

#@onready var model_rot = model.rotation.x


func use():
	for cleaver in active_cleavers:
		cleaver.stay()

	if current_cooldown > 0.0:
		return

	if active_cleavers.size() < cleaver_count:
		var new_cleaver: Node3D = projectile.instantiate()
		new_cleaver.target_position = (
			cam.global_position + (-cam.global_transform.basis.z * throw_dist)
		)
		new_cleaver.player_owner = get_parent().player
		new_cleaver.go_back_target = cam
		new_cleaver.delete.connect(func(): active_cleavers.erase(new_cleaver))
		get_tree().root.add_child(new_cleaver)
		new_cleaver.global_position = cam.global_position
		active_cleavers.append(new_cleaver)

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


func _physics_process(delta: float) -> void:
	current_cooldown -= delta
	self.visible = active_cleavers.size() < cleaver_count
