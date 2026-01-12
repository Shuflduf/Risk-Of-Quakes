class_name Skill
extends Node

# all skills should have a used signal, with any params it wants
# signal used

@export var info: SkillInfo

enum SkillSlot {
	PRIMARY,
	SECONDARY,
	UTILITY,
	SPECIAL,
}
