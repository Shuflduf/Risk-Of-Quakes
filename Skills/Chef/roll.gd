extends Skill

signal revert_abilities
signal used

@export var skill_duration = 2.0
@export var jump_height = 8.0
@export var knockback_strength = 10.0
@export var boost_damage_frequency = 0.3

var cooldown = 0.0
var active = false
var current_direction = Vector3.ZERO
var movement_speed = 0.0
var elapsed_duration = 0.0
var used_jump = false
var boosted = false
var boost_active = false
var boost_damage_cooldown = 0.0

@onready var player: CharacterBody3D = get_parent().player
@onready var cam_systems: CameraSystemManager = get_parent().cam_systems
@onready var hurtbox: Area3D = $Hurtbox
@onready var boost_hurtbox: Area3D = $BoostHurtbox


func use():
	if cooldown > 0.0:
		return
	player.jump_enabled = false
	active = true
	var cam_dir = Vector3(-sin(player.rotation.y), 0.0, -cos(player.rotation.y))
	var target_vel = player.velocity if !player.wish_dir.is_zero_approx() else cam_dir
	calculate_speed(Utils.flatten_vec(player.velocity).length())
	current_direction = Utils.flatten_vec(target_vel).normalized()
	elapsed_duration = 0.0
	cooldown = INF
	used_jump = false
	used.emit()
	enabled = false
	if boosted:
		boost_active = true
		revert_abilities.emit()


func _physics_process(delta: float) -> void:
	cooldown -= delta
	boost_damage_cooldown -= delta
	if active:
		if !player.wish_dir.is_zero_approx():
			current_direction = current_direction.slerp(player.wish_dir, delta * 2.0)
		player.velocity.x = current_direction.x * movement_speed
		player.velocity.z = current_direction.z * movement_speed
		elapsed_duration += delta
		if elapsed_duration >= 3.0:
			active = false
			player.jump_enabled = true
			enabled = true
			cooldown = info.cooldown
			cooldown_started.emit()
			boost_active = false
		if Input.is_action_just_pressed(&"jump") and !used_jump:
			player.velocity.y = jump_height
			used_jump = true
		if self.call(&"has_overlapping_bodies") and player.velocity.y < 8.0:
			player.velocity.y += delta * 20.0
		if boost_active and boost_damage_cooldown <= 0.0:
			for hitbox in boost_hurtbox.get_overlapping_areas():
				if hitbox.player_owner == player:
					continue

				hitbox.hit(6)
				var target_player = hitbox.player_owner
				var target_speed = target_player.velocity.length()
				var very_fast = target_speed > 10.0
				var speed_mult = 0.5 if very_fast else 0.9
				target_player.velocity *= speed_mult

				boost_damage_cooldown = boost_damage_frequency


func calculate_speed(base_speed: float):
	if boosted:
		movement_speed = max(15.0, base_speed + 5.0)
	else:
		movement_speed = max(10.0, base_speed + 2.0)


func _on_hurtbox_area_entered(hitbox: Area3D) -> void:
	if hitbox.player_owner == player or not active:
		return
	hitbox.hit(8)
	var knockback_vec = Utils.flatten_vec(
		player.global_position.direction_to(hitbox.player_owner.global_position)
	)
	knockback_vec.y = 1.5
	knockback_vec *= movement_speed * 0.5
	hitbox.knockback(knockback_vec)
