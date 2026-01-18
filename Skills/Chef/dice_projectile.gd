extends Node3D

signal delete

enum State {
	GOING,
	STAYING,
	BACK,
}

@export var speed = 20.0

var target_position: Vector3
var player_owner: CharacterBody3D
var go_back_target: Node3D
var from_boost = false

var held_down = true
var held_time = 0.0
var state: State = State.GOING

@onready var hurtbox: Area3D = $Hurtbox
@onready var damage_cooldown: Timer = $DamageCooldown


func stay():
	if not from_boost:
		held_down = true


func _physics_process(delta: float) -> void:
	rotation.y += delta * 30.0

	match state:
		State.GOING:
			global_position += global_position.direction_to(target_position) * delta * speed
			if global_position.distance_to(target_position) < 0.2:
				state = State.STAYING
		State.STAYING:
			if held_down:
				held_time += delta
			else:
				state = State.BACK
		State.BACK:
			global_position += (
				global_position.direction_to(go_back_target.global_position) * delta * speed
			)
			if global_position.distance_to(go_back_target.global_position) < 0.5:
				queue_free()
				delete.emit()

	if held_down:
		held_down = false


func _on_collision_body_entered(_body: Node3D) -> void:
	if state == State.GOING:
		state = State.STAYING


func _on_hurtbox_area_entered(area: Area3D) -> void:
	if area.player_owner != player_owner:
		area.hit(get_damage())
		hurtbox.set_deferred(&"monitoring", false)
		damage_cooldown.start()


func _on_damage_cooldown_timeout() -> void:
	hurtbox.monitoring = true


func get_damage() -> int:
	match state:
		State.GOING:
			return 5
		State.STAYING:
			return 3
		State.BACK:
			return 10 if held_time > 0.5 else 5
	return 9999
