extends Node

@export var offset: Vector3

@onready var weapon: Node3D = get_parent()
@onready var cam: Camera3D = weapon.get_parent().cam


func _process(delta: float) -> void:
	#weapon.transform = cam.transform.translated_local(offset)
	weapon.position = weapon.position.lerp(
		cam.transform.translated_local(offset).origin, delta * 20.0
	)
	weapon.rotation = weapon.rotation.lerp(cam.rotation, delta * 20.0)
