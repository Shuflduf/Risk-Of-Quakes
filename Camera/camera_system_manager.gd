class_name CameraSystemManager
extends Node

@onready var default_cam_transform: Marker3D = $"../DefaultCamPos"

@export var cam: Camera3D

func _process(_delta: float) -> void:
	cam.position = default_cam_transform.position
	cam.rotation = default_cam_transform.rotation
	for sys: CameraSystem in get_children():
		cam.position += sys.position_offset
		cam.rotation += sys.rotation_offset
