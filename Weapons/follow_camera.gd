extends Node

@export var offset: Vector3

var cam: Camera3D

@onready var weapon: Node3D = get_parent()

func _process(_delta: float) -> void:
	weapon.transform = cam.transform.translated_local(offset)
