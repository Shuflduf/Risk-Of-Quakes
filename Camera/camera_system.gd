class_name CameraSystem
extends Node

@onready var manager: CameraSystemManager = get_parent()
@onready var cam: Camera3D = manager.cam

var position_offset: Vector3
var rotation_offset: Vector3
