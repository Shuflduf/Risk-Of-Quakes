extends Node3D

@onready var player: CharacterBody3D = get_parent()

var last_player_vel = Vector3.ZERO
var rays: Array[CollisionShape3D]

func _ready() -> void:
	for ray in get_children():
		rays.append(ray)
		
		ray.reparent.call_deferred(player)
		
func _physics_process(delta: float) -> void:
	pass
	for ray in rays:
		var dir = flatten_vec(ray.position).normalized()
		var player_delta = player.velocity / 10.0
		player_delta = Vector3(player_delta.x, 0.0, player_delta.z)
		var ray_pos = dir * (1 + player_delta.length()) * 0.5
		ray.position.x = ray_pos.x
		ray.position.z = ray_pos.z
		print(ray.position)
			

func flatten_vec(input: Vector3) -> Vector3:
	return Vector3(input.x, 0.0, input.z)
