extends Skill

signal used

@export var nade_scene: PackedScene
@export var damage = 15

var cooldown = 0.0

@onready var cam: Camera3D = get_parent().cam
@onready var player: CharacterBody3D = get_parent().player


func start():
	throw()


func _physics_process(delta: float) -> void:
	cooldown -= delta


func throw():
	if cooldown > 0.0:
		return

	var new_nade: RigidBody3D = nade_scene.instantiate()
	get_tree().root.add_child(new_nade)
	new_nade.damage = damage
	new_nade.player_owner = player
	new_nade.global_position = cam.global_position
	new_nade.linear_velocity = player.velocity + (-cam.global_transform.basis.z * 15.0)
	cooldown = info.cooldown

	used.emit()
	cooldown_started.emit()
