extends Node3D

var speed = 15.0
var player_owner: CharacterBody3D

func _physics_process(delta: float) -> void:
	transform = transform.translated_local(Vector3.FORWARD * delta * speed)


func _on_hurtbox_area_entered(area: Area3D) -> void:
	if area.name == &"Hitbox" and area.get_parent() != player_owner:
		area.hit(roundi(speed / 3.0))
