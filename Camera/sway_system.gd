extends CameraSystem

@export var mouse_system: CameraSystem

func _process(delta: float) -> void:
	rotation_offset.z = lerp(rotation_offset.z, 0.0, delta * 10)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		var mouse_movement = -event.screen_relative * mouse_system.actual_mouse_sens / 50
		rotation_offset.z += mouse_movement.x
	
	
