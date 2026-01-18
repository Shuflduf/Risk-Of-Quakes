extends Skill

signal revert_abilities
signal used(activated: bool, boosted: bool)

@export var damage_freqency = 0.1

var cooldown = 0.0
var damage_cooldown = 0.0
var active = false
var boosted = false
var boost_active = false

@onready var player: CharacterBody3D = get_parent().player
@onready var particles: GPUParticles3D = $Particles
@onready var active_timer: Timer = $ActiveTimer
@onready var hurtbox: Area3D = $Hurtbox


func use():
	if cooldown > 0.0:
		return
	particles.emitting = true
	active_timer.start()
	cooldown = INF
	used.emit(true)
	enabled = false
	active = true


func _physics_process(delta: float) -> void:
	cooldown -= delta
	damage_cooldown -= delta
	if active and damage_cooldown < 0.0:
		for hitbox in hurtbox.get_overlapping_areas():
			if hitbox.player_owner != player:
				hitbox.hit(2)
				damage_cooldown = damage_freqency


func _on_active_timer_timeout() -> void:
	particles.emitting = false
	enabled = true
	cooldown_started.emit()
	cooldown = info.cooldown
	used.emit(false)
	active = false
