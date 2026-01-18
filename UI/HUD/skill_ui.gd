extends Control

@onready var timer: Timer = $Timer
@onready var progress_bar: ProgressBar = $ProgressBar
@onready var countdown: Label = $Countdown

var enabled = true


func create(info: SkillInfo):
	tooltip_text = info.skill_name
	timer.wait_time = info.cooldown


func _process(_delta: float) -> void:
	if enabled:
		progress_bar.visible = !timer.is_stopped() and timer.wait_time > 1.0
		countdown.visible = progress_bar.visible
		countdown.text = str(ceili(timer.time_left))
		progress_bar.value = 100.0 * (timer.time_left / timer.wait_time)


func use():
	timer.start()


func disable():
	enabled = false
	countdown.hide()
	progress_bar.value = 0
	progress_bar.show()


func enable():
	enabled = true
	# could be a very bad idea
	timer.stop()
