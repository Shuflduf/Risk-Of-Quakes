extends Area3D

@onready var timer: Timer = $Timer


func pickup():
	hide()
	set_deferred(&"monitorable", false)
	timer.start()


func _on_timer_timeout() -> void:
	monitorable = true
	show()
