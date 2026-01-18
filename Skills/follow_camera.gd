extends Node

@export var offset: Vector3

@onready var weapon: Node3D = get_parent()
@onready var cam: Camera3D = weapon.get_parent().cam


func _process(_delta: float) -> void:
	weapon.transform = cam.transform.translated_local(offset)
