extends Skill

@export var projectile: PackedScene

var current_cooldown = 0.0
var active_cleavers: Array[Node3D]

@onready var cam: Camera3D = get_parent().cam

func use():
	for cleaver in active_cleavers:
		cleaver.stay()
	
	if current_cooldown > 0.0:
		return
		
	var new_cleaver: Node3D = projectile.instantiate()
	new_cleaver.target_position = cam.global_position + (-cam.global_transform.basis.z * 15.0)
	new_cleaver.player = cam
	new_cleaver.delete.connect(func(): active_cleavers.erase(new_cleaver))
	get_tree().root.add_child(new_cleaver)
	new_cleaver.global_position = cam.global_position
	active_cleavers.append(new_cleaver)
	
	current_cooldown = info.cooldown

func _physics_process(delta: float) -> void:
	current_cooldown -= delta
