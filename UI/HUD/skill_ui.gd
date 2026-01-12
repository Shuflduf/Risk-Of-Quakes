extends Control

@onready var timer: Timer = $Timer
@onready var progress_bar: ProgressBar = $ProgressBar
@onready var countdown: Label = $Countdown

func create(info: SkillInfo):
	tooltip_text = info.skill_name
	timer.wait_time = info.cooldown

func _process(_delta: float) -> void:
	progress_bar.visible = !timer.is_stopped() and timer.wait_time > 1.0
	countdown.visible = progress_bar.visible
	countdown.text = str(ceili(timer.time_left))
	progress_bar.value = 100.0 * (timer.time_left / timer.wait_time)
	# 0.25

func use():
	timer.start()
