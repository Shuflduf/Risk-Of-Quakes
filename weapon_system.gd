extends Node3D

@export var cam: Camera3D

func _ready() -> void:
	for weapon in get_children():
		var follow_cam_node = weapon.get_node(^"FollowCamera")
		if follow_cam_node:
			follow_cam_node.cam = cam
