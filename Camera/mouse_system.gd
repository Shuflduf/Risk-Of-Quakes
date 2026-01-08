extends CameraSystem

const MOUSE_SENS_MULTIPLIER = 0.001

@export var third_person: bool
@export var mouse_sens = 0.8
@export var third_person_pos: Marker3D

var actual_mouse_sens = MOUSE_SENS_MULTIPLIER * mouse_sens

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED if Input.mouse_mode == Input.MOUSE_MODE_VISIBLE else Input.MOUSE_MODE_VISIBLE

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		var mouse_movement = -event.screen_relative * actual_mouse_sens
		rotation_offset.y += mouse_movement.x
		rotation_offset.x += mouse_movement.y
		
		print(rotation_offset.y)
		if third_person:
			position_offset = third_person_pos.position.rotated(Vector3.UP, rotation_offset.y)
			position_offset.y = -rotation_offset.x
