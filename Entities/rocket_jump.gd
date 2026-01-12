extends Node

@onready var player: CharacterBody3D = get_parent()

func jump(vec: Vector3):
	player.velocity += vec
