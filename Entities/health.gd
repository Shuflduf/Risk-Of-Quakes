class_name HealthSystem
extends Node

signal health_changed(new_health)

@export var max_health = 100

var last_attacker: Node3D = null
var health = max_health:
	set(new_val):
		health = new_val
		health_changed.emit(new_val)
