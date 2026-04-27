extends Node

@export var cam: Camera3D
@export var skills: Node3D
@export var cam_systems: CameraSystemManager
@export var hud: Control
@export var skin: Node3D
@export var health: HealthSystem
@export var hitbox: Area3D

var is_dead = false

@onready var player: CharacterBody3D = get_parent()


func _ready() -> void:
	if !is_multiplayer_authority():
		set_process_input(false)
		set_process_unhandled_input(false)
		set_process_unhandled_key_input(false)
		cam.current = false
		hud.hide()
	else:
		cam.current = true
		cam.fov = Settings.fov
		#player.rotation.y = 0.0
		hud.disconnected.connect(disconnect_player.rpc)
		hud.update_health(health.health)
		hud.reconstruct_leaderboard()
		Lobby.leaderboard_updated.connect(hud.reconstruct_leaderboard)
		
		Settings.fov_updated.connect(func(new_fov: float): cam.fov = new_fov)

		for slot in skills.skill_list:
			var target_skill: Skill = skills.skill_list[slot]
			hud.add_skill(target_skill.info, slot)
			hud.toggle_skill(target_skill.enabled, slot)
			target_skill.cooldown_started.connect(func(): hud.skill_used(slot))
			target_skill.enabled_changed.connect(
				func(): hud.toggle_skill(target_skill.enabled, slot)
			)
			target_skill.skill_info_changed.connect(
				func(new_info): hud.change_skill_info(new_info, slot)
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
		#skin.rotation.y = cam.rotation.y

	if !is_multiplayer_authority() or is_dead or player.input_disabled():
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




func _on_health_changed(new_health: int):
	if new_health <= 0:
		die.rpc()


@rpc("any_peer", "call_local")
func die():
	if is_dead:
		return

	hitbox.set_deferred(&"monitorable", false)
	player.hide()
	player.enable_movement(false)
	is_dead = true
	hud.respawn(5.0)
	prints(multiplayer.get_unique_id(), multiplayer.get_remote_sender_id())
	Lobby.players[multiplayer.get_remote_sender_id()].deaths += 1
	var killer = health.last_attacker
	if killer and killer.get_multiplayer_authority():
		Lobby.players[killer.get_multiplayer_authority()].kills += 1
	Lobby.sync_leaderboard()
	var killer_focus_system = cam_systems.get_node(^"KillerFocus")
	killer_focus_system.killer = health.last_attacker
	get_tree().create_timer(5.0).timeout.connect(respawn)


@rpc("any_peer", "call_local")
func respawn():
	hitbox.set_deferred(&"monitorable", true)
	player.show()
	player.enable_movement(true)
	player.velocity = Vector3.ZERO
	is_dead = false
	health.health = 100
	var killer_focus_system = cam_systems.get_node(^"KillerFocus")
	killer_focus_system.killer = null
	var spawn_pos = get_tree().get_nodes_in_group(&"Spawn Point").pick_random()
	cam_systems.reset_all()
	player.global_position = spawn_pos.position
	player.global_rotation = spawn_pos.rotation

@rpc("any_peer", "call_local")
func disconnect_player():
	if multiplayer.get_unique_id() == multiplayer.get_remote_sender_id():
		Lobby.remove_multiplayer_peer()
	else:
		player.queue_free()
	
