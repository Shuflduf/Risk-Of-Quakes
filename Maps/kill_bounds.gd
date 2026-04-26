extends Area3D


func _on_area_entered(area: Area3D) -> void:
	area.hit(null, 1225)
