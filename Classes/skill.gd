class_name Skill
extends Node

# all skills should have a used signal, with any params it wants
# signal used

signal enabled_changed

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
