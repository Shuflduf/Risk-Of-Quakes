extends Node

@export var cam: Camera3D
@export var skills: Node3D

@onready var player: CharacterBody3D = get_parent()

func _physics_process(_delta: float) -> void:
	var input_dir = Input.get_vector(&"left", &"right", &"forward", &"backward").rotated(-cam.rotation.y)
	player.wish_dir = Vector3(input_dir.x, 0.0, input_dir.y)
	if Input.is_action_pressed(&"jump") and player.is_on_floor() and player.jump_enabled:
		player.wish_jump = true
	
	if Input.is_action_pressed(&"primary"):
		skills.primary()
		
	if Input.is_action_pressed(&"secondary"):
		skills.secondary()
	
	if Input.is_action_pressed(&"utility"):
		skills.utility()
