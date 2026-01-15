extends Skill

signal used

@export var skill_name: String
@export var nade_scene: PackedScene

@onready var cam: Camera3D = get_parent().cam
@onready var player: CharacterBody3D = get_parent().player

var cooldown = 0.0

func _physics_process(delta: float) -> void:
	cooldown -= delta
	
func use():
	if cooldown > 0.0:
		return
		
	var new_nade: RigidBody3D = nade_scene.instantiate()
	get_tree().root.add_child(new_nade)
	new_nade.global_position = cam.global_position
	new_nade.linear_velocity = player.velocity + (-cam.basis.z.normalized() * 15.0)
	cooldown = info.cooldown
	
	used.emit()
	cooldown_started.emit()
