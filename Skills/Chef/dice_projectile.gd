extends Node3D

signal delete

@export var speed = 20.0

enum State {
	Going,
	Staying,
	Back,
}

var target_position: Vector3
var player_owner: CharacterBody3D
var go_back_target: Node3D

var held_down = true
var held_time = 0.0
var state: State = State.Going

@onready var hurtbox: Area3D = $Hurtbox
@onready var damage_cooldown: Timer = $DamageCooldown


func stay():
	held_down = true


func _physics_process(delta: float) -> void:
	rotation.y += delta * 30.0

	match state:
		State.Going:
			global_position += global_position.direction_to(target_position) * delta * speed
			if global_position.distance_to(target_position) < 0.1:
				state = State.Staying
		State.Staying:
			if held_down:
				held_time += delta
			else:
				state = State.Back
		State.Back:
			global_position += (
				global_position.direction_to(go_back_target.global_position) * delta * speed
			)
			if global_position.distance_to(go_back_target.global_position) < 0.5:
				queue_free()
				delete.emit()

	if held_down:
		held_down = false


func _on_collision_body_entered(_body: Node3D) -> void:
	if state == State.Going:
		state = State.Staying


func _on_hurtbox_area_entered(area: Area3D) -> void:
	if area.player_owner != player_owner:
		area.hit(get_damage())
		hurtbox.set_deferred(&"monitoring", false)
		damage_cooldown.start()


func _on_damage_cooldown_timeout() -> void:
	hurtbox.monitoring = true


func get_damage() -> int:
	match state:
		State.Going:
			return 5
		State.Staying:
			return 3
		State.Back:
			return 10 if held_time > 0.5 else 5
	return 9999
