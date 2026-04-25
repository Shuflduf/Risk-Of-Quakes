extends Skill

signal revert_abilities
signal used(activated: bool, boosted: bool)

@export var alternate_icon: Texture2D
@export_multiline var alternate_description: String
@export var damage_freqency = 0.1
@export var base_damage = 2
@export var boost_damage = 4

var cooldown = 0.0
var damage_cooldown = 0.0
var active = false
var boosted = false
var boost_active = false

@onready var player: CharacterBody3D = get_parent().player
@onready var particles: GPUParticles3D = $Particles
@onready var active_timer: Timer = $ActiveTimer
@onready var hurtbox: Area3D = $Hurtbox
@onready var boost_particles: GPUParticles3D = $BoostParticles
@onready var boost_hurtbox: Area3D = $BoostHurtbox


func start():
	if cooldown > 0.0:
		return

	if boosted:
		boost_particles.emitting = true
		boost_active = true
		revert_abilities.emit()
		used.emit(true, true)
	else:
		particles.emitting = true
		used.emit(true, false)

	active_timer.start()
	cooldown = INF

	enabled = false
	active = true


func _physics_process(delta: float) -> void:
	cooldown -= delta
	damage_cooldown -= delta
	if active and damage_cooldown < 0.0:
		var target_hurtbox = boost_hurtbox if boost_active else hurtbox
		var damage = boost_damage if boost_active else base_damage
		for hitbox in target_hurtbox.get_overlapping_areas():
			if hitbox.player_owner != player:
				hitbox.hit(player, damage)
				damage_cooldown = damage_freqency


func _on_active_timer_timeout() -> void:
	if boost_active:
		boost_particles.emitting = false
		boost_active = false
		used.emit(false, true)
	else:
		particles.emitting = false
		used.emit(false, false)
	enabled = true
	cooldown_started.emit()
	cooldown = info.cooldown

	active = false
