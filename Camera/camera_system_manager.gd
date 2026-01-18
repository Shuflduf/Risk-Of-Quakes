class_name CameraSystemManager
extends Node

@export var cam: Camera3D
@onready var default_cam_transform = cam.transform


func _process(_delta: float) -> void:
	cam.position = default_cam_transform.origin
	cam.rotation = default_cam_transform.basis.get_euler()
	for sys: CameraSystem in get_children():
		cam.position += sys.position_offset
		cam.rotation += sys.rotation_offset
