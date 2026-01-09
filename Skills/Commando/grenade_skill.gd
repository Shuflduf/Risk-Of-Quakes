extends Node

@export var nade_scene: PackedScene
@export var skill_cooldown = 1.0

@onready var cam: Camera3D = get_parent().cam
@onready var player: CharacterBody3D = get_parent().player

var current_cooldown = 0.0

func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed(&"special") and current_cooldown <= 0.0:
		var new_nade: RigidBody3D = nade_scene.instantiate()
		add_child(new_nade)
		new_nade.global_position = cam.global_position
		new_nade.linear_velocity = -cam.basis.z.normalized() * 15.0
