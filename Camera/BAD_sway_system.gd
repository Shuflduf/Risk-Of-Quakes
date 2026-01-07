extends CameraSystem


@export var player: CharacterBody3D

const VERTICAL_SWAY_SPEED = 12.0
const HORIZONTAL_SWAY_SPEED = 6.0

var sway_progress = 0.0

func _process(delta: float) -> void:
	var should_sway = player.is_moving && player.is_on_floor()
	if should_sway:
		var transition_progress = min(sway_progress, 1.0)
		sway_progress += delta
		position_offset.y = lerp(position_offset.y, cos(sway_progress * VERTICAL_SWAY_SPEED) / 5.0, transition_progress)
		var horizontal_offset = lerp(0.0, sin(sway_progress * HORIZONTAL_SWAY_SPEED) / 5.0, transition_progress)
		position_offset.x = cos(cam.rotation.y) * horizontal_offset
		position_offset.z = sin(cam.rotation.y) * horizontal_offset
		#position_offset = position_offset.lerp(, transition_progress)

		rotation_offset.y = sin(sway_progress * HORIZONTAL_SWAY_SPEED) / 50.0
	else:
		position_offset = position_offset.lerp(Vector3.ZERO, delta * 5)
		rotation_offset.y = lerp(rotation_offset.y, 0.0, delta * 5)
		sway_progress = 0.0
