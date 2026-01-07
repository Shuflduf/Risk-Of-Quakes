extends CameraSystem

const MOUSE_SENS_MULTIPLIER = 0.001

@export var mouse_sens = 0.8

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
