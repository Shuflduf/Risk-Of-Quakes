extends Node3D

@onready var player: CharacterBody3D = get_parent()

var last_player_vel = Vector3.ZERO
var rays: Array[CollisionShape3D]

func _ready() -> void:
	for ray in get_children():
		rays.append(ray)
		
		ray.reparent.call_deferred(player)
		
func _physics_process(_delta: float) -> void:
	for ray in rays:
		var dir = flatten_vec(ray.position).normalized()
		var vel = flatten_vec(player.velocity) / 10.0
		var ray_pos = dir * (1 + vel.length()) * 0.55
		ray.position.x = ray_pos.x
		ray.position.z = ray_pos.z
		# this may be the root of evil for future me
		ray.disabled = player.velocity.y > 0.2
			

func flatten_vec(input: Vector3) -> Vector3:
	return Vector3(input.x, 0.0, input.z)
