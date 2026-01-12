extends Control

@export var skill_ui: PackedScene

var registered_skills: Dictionary[Skill.SkillSlot, Node]

func add_skill(skill_info: SkillInfo, slot: Skill.SkillSlot):
	var new_skill_ui = skill_ui.instantiate()
	%SkillsContainer.add_child(new_skill_ui)
	registered_skills[slot] = new_skill_ui
	new_skill_ui.create(skill_info)
	prints(skill_info.skill_name, slot)

func skill_used(slot: Skill.SkillSlot):
	registered_skills[slot].use()
	print(slot)

func toggle_skill(on: bool, slot: Skill.SkillSlot):
	if on:
		registered_skills[slot].enable()
	else:
		registered_skills[slot].disable()

#func enable_skill(slot: Skill.SkillSlot):
	#registered_skills[slot].enable()
	#print(slot)
