class_name Skill
extends Node

# all skills should have a used signal, with any params it wants
# signal used

signal enabled_changed

@warning_ignore("unused_signal")
signal cooldown_started

@warning_ignore("unused_signal")
signal icon_changed(new_icon: Texture2D)

enum SkillSlot {
	PRIMARY,
	SECONDARY,
	UTILITY,
	SPECIAL,
}

@export var info: SkillInfo

var enabled: bool = true:
	set(new_val):
		enabled = new_val
		enabled_changed.emit()


func start():
	pass


func finish():
	pass
