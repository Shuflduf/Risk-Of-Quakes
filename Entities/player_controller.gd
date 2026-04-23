extends Node

@export var cam: Camera3D
@export var skills: Node3D
@export var cam_systems: CameraSystemManager
@export var hud: Control
@export var skin: Node3D

@onready var player: CharacterBody3D = get_parent()


func _ready() -> void:
	if !is_multiplayer_authority():
		set_process_input(false)
		set_process_unhandled_input(false)
		set_process_unhandled_key_input(false)
		cam.current = false
	else:
		cam.current = true
		player.rotation.y = 0.0

		for slot in skills.skill_list:
			var target_skill = skills.skill_list[slot]
			hud.add_skill(target_skill.info, slot)
			hud.toggle_skill(target_skill.enabled, slot)
			target_skill.cooldown_started.connect(func(): hud.skill_used(slot))
			target_skill.enabled_changed.connect(
				func(): hud.toggle_skill(target_skill.enabled, slot)
			)

	if skin:
		skin.connect_skills(skills.skill_list)


func _physics_process(_delta: float) -> void:
	if skin:
		skin.visible = get_viewport().get_camera_3d() != cam
		skills.visible = !skin.visible
		skin.set_spine_angle(-cam.rotation.x)

	if !is_multiplayer_authority():
		return

	var input_dir = Input.get_vector(&"left", &"right", &"forward", &"backward").rotated(
		-player.rotation.y
	)
	player.wish_dir = Vector3(input_dir.x, 0.0, input_dir.y)
	if Input.is_action_pressed(&"jump") and player.is_on_floor() and player.jump_enabled:
		player.wish_jump = true

	if Input.is_action_just_pressed(&"primary"):
		skills.primary(true)
	elif Input.is_action_just_released(&"primary"):
		skills.primary(false)

	if Input.is_action_just_pressed(&"secondary"):
		skills.secondary(true)
	elif Input.is_action_just_released(&"secondary"):
		skills.secondary(false)

	if Input.is_action_just_pressed(&"utility"):
		skills.utility(true)
	elif Input.is_action_just_released(&"utility"):
		skills.utility(false)

	if Input.is_action_just_pressed(&"special"):
		skills.special(true)
	elif Input.is_action_just_released(&"special"):
		skills.special(false)

	if skin:
		skin.rotation.y = cam.rotation.y
