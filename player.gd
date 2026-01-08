extends CharacterBody3D

@warning_ignore("unused_signal")
signal jumped

@onready var cam: Camera3D = %Camera

#const SPEED = 8.0
#const JUMP_VELOCITY = 7.0

const MAX_VELOCITY_AIR = 0.6
const MAX_VELOCITY_GROUND = 6.0
const MAX_ACCELERATION = 10 * MAX_VELOCITY_GROUND
const GRAVITY = 15.34
const STOP_SPEED = 1.5
const JUMP_IMPULSE = 5.5
const FRICTION = 4.0

var wish_jump = false
var wish_dir = Vector3.ZERO

func _physics_process(delta: float) -> void:
	_process_inputs()
	_process_movement(delta)
	
	move_and_slide()

func _process_inputs():
	var input_dir = Input.get_vector(&"left", &"right", &"forward", &"backward").rotated(-cam.rotation.y)
	wish_dir = Vector3(input_dir.x, 0.0, input_dir.y)
	if Input.is_action_pressed(&"jump") and is_on_floor():
		wish_jump = true

func _process_movement(delta: float):
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
