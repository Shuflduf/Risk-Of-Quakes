extends Area3D

func hit(damage: float):
	var new_damage_text: Label3D = $BaseText.duplicate()
	get_tree().root.add_child(new_damage_text)
	new_damage_text.top_level = true
	new_damage_text.visible = true
	new_damage_text.text = str(roundi(damage))
	new_damage_text.global_position = global_position
	#var random_dir = Vector2(randf_range(-1.0, 1.0), randf_range(-1.0, 1.0)).normalized()
	var tween = get_tree().create_tween()
	tween.tween_property(new_damage_text, ^"position:y", 2.0, 0.5).as_relative()
	tween.tween_callback(new_damage_text.queue_free)
	prints(name, damage)
