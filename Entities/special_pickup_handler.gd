extends Area3D

@export var skill_system: Node


func _on_area_entered(area: Area3D) -> void:
	skill_system.give_special()
	area.pickup()
