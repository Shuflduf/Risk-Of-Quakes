extends MeshInstance3D

@onready var player: CharacterBody3D = $".."

func update():
	var air_time = (2 * player.JUMP_VELOCITY) / player.get_gravity().y
	var offset = air_time * (player.velocity * Vector3(1.0, 0.0, 1.0))

	position = player.position - offset
	position.y -= 1.0
