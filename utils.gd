extends Node


func flatten_vec(input: Vector3) -> Vector3:
	return Vector3(input.x, 0.0, input.z)
