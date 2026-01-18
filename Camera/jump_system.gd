extends CameraSystem

@export var player: CharacterBody3D
@export var jump_curve: Curve

var time_since_jump = 0.0


func _ready() -> void:
	player.jumped.connect(_on_player_jump)


func _on_player_jump():
	time_since_jump = 0.0


func _process(delta: float) -> void:
	if player.is_on_floor():
		time_since_jump = 0.0
	else:
		time_since_jump += delta
	rotation_offset.x = jump_curve.sample_baked(min(time_since_jump, 1.0))
