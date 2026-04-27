extends CharacterBody3D

enum MovementMode {
	FULL,
	NO_INPUT,
	NONE,
}

@warning_ignore("unused_signal")
signal jumped

const MAX_VELOCITY_AIR = 0.6
const MAX_VELOCITY_GROUND = 6.0
const MAX_ACCELERATION = 10 * MAX_VELOCITY_GROUND
const GRAVITY = 15.34
const STOP_SPEED = 1.5
const JUMP_IMPULSE = 4
const FRICTION = 4.0
const REGAIN_CONTROL_TIME = 0.3

var wish_jump = false
var wish_dir = Vector3.ZERO
var jump_enabled = true
var movement_state: MovementMode = MovementMode.FULL
var regain_control_timer = 0.0

func _physics_process(delta: float) -> void:
	if movement_state == MovementMode.NONE:
		return
	
	_process_movement(delta)
	move_and_slide()


func _process_movement(delta: float):
	if movement_state == MovementMode.NO_INPUT:
		regain_control_timer += delta
		if regain_control_timer > REGAIN_CONTROL_TIME and is_on_floor():
			movement_state = MovementMode.FULL
	
	if is_on_floor():
		
		
		if wish_jump:
			velocity.y = JUMP_IMPULSE
			velocity = update_velocity_air(delta)
			wish_jump = false
		else:
			velocity = update_velocity_ground(delta)
	else:
		velocity += get_gravity() * delta
		velocity = update_velocity_air(delta)


func update_velocity_ground(delta: float) -> Vector3:
	var speed = velocity.length()
	if !is_zero_approx(speed):
		var control = max(STOP_SPEED, speed)
		var drop = control * FRICTION * delta
		velocity *= max(speed - drop, 0) / speed

	return accelerate(MAX_VELOCITY_GROUND, delta)


func update_velocity_air(delta: float) -> Vector3:
	return accelerate(MAX_VELOCITY_AIR, delta)


func accelerate(max_velocity: float, delta: float) -> Vector3:
	var current_speed = velocity.dot(wish_dir)
	var add_speed = clamp(max_velocity - current_speed, 0, MAX_ACCELERATION * delta)

	return velocity + add_speed * wish_dir


func enable_movement(enable: bool):
	movement_state = MovementMode.FULL if enable else MovementMode.NONE


func fly_to(target_position: Vector3):
	movement_state = MovementMode.NO_INPUT
	wish_dir = Vector3.ZERO
	regain_control_timer = 0.0
	velocity = compute_initial_velocity_to_reach_point(global_position, target_position, 10.0, -get_gravity().y)
	


func input_disabled() -> bool:
	return movement_state == MovementMode.NO_INPUT


func compute_initial_velocity_to_reach_point(
	start_position: Vector3,
	target_position: Vector3,
	horizontal_speed: float,
	gravity_magnitude: float
) -> Vector3:
	var displacement: Vector3 = target_position - start_position
	var horizontal_displacement: Vector3 = Vector3(displacement.x, 0.0, displacement.z)
	var horizontal_distance: float = horizontal_displacement.length()

	var time_to_target: float = max(0.05, horizontal_distance / max(0.01, horizontal_speed))
	var gravity_acceleration_y: float = -gravity_magnitude

	for iteration in 20:
		var initial_velocity_y: float = (displacement.y - 0.5 * gravity_acceleration_y * time_to_target * time_to_target) / time_to_target
		var final_velocity_y: float = initial_velocity_y + gravity_acceleration_y * time_to_target
		if final_velocity_y < 0.0:
			var initial_velocity_horizontal: Vector3 = horizontal_displacement / time_to_target
			return Vector3(
				initial_velocity_horizontal.x,
				initial_velocity_y,
				initial_velocity_horizontal.z
			)

		time_to_target *= 1.1

	var initial_velocity_y_fallback: float = (displacement.y - 0.5 * gravity_acceleration_y * time_to_target * time_to_target) / time_to_target
	var initial_velocity_horizontal_fallback: Vector3 = horizontal_displacement / time_to_target
	return Vector3(
		initial_velocity_horizontal_fallback.x,
		initial_velocity_y_fallback,
		initial_velocity_horizontal_fallback.z
	)
