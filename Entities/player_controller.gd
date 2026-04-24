extends Node

@export var cam: Camera3D
@export var skills: Node3D
@export var cam_systems: CameraSystemManager
@export var hud: Control
@export var skin: Node3D
@export var health: HealthSystem

@onready var player: CharacterBody3D = get_parent()

var is_dead = false

func _ready() -> void:
	if !is_multiplayer_authority():
		set_process_input(false)
		set_process_unhandled_input(false)
		set_process_unhandled_key_input(false)
		cam.current = false
		hud.hide()
	else:
		cam.current = true
		player.rotation.y = 0.0
		hud.update_health(health.health)

		for slot in skills.skill_list:
			var target_skill = skills.skill_list[slot]
			hud.add_skill(target_skill.info, slot)
			hud.toggle_skill(target_skill.enabled, slot)
			target_skill.cooldown_started.connect(func(): hud.skill_used(slot))
			target_skill.enabled_changed.connect(
				func(): hud.toggle_skill(target_skill.enabled, slot)
			)
		health.health_changed.connect(hud.update_health)
		health.health_changed.connect(_on_health_changed)

	if skin:
		skin.connect_skills(skills.skill_list)


func _physics_process(_delta: float) -> void:
	if skin:
		skin.visible = get_viewport().get_camera_3d() != cam
		skills.visible = !skin.visible
		skin.set_spine_angle(-cam.rotation.x)

	if !is_multiplayer_authority() or is_dead:
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


func _on_health_changed(new_health: int):
	if new_health <= 0:
		die.rpc()

@rpc("any_peer", "call_local")
func die():
	player.hide()
	is_dead = true
	get_tree().create_timer(2.0).timeout.connect(respawn)
	var killer_focus_system = cam_systems.get_node(^"KillerFocus")
	killer_focus_system.killer = health.last_attacker

@rpc("any_peer", "call_local")
func respawn():
	player.show()
	is_dead = false
	health.health = 100
	var killer_focus_system = cam_systems.get_node(^"KillerFocus")
	killer_focus_system.killer = null
