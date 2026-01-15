extends Node3D

signal delete

@export var speed = 20.0

enum State {
	Going,
	Staying,
	Back,
}

var target_position: Vector3
var held_down = true
var player: Node3D
var state: State = State.Going


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
			if !held_down:
				state = State.Back
		State.Back:
			global_position += global_position.direction_to(player.global_position) * delta * speed
			if global_position.distance_to(player.global_position) < 0.5:
				queue_free()
				delete.emit()
	
	if held_down: 
		held_down = false
	


func _on_collision_body_entered(_body: Node3D) -> void:
	if state == State.Going:
		state = State.Staying
