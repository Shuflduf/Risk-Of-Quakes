extends Control

@export var skill_ui: PackedScene

var registered_skills: Dictionary[Skill.SkillSlot, Node]

@onready var skills_container: HBoxContainer = %SkillsContainer
@onready var health_bar: ProgressBar = %HealthBar
@onready var health_label: Label = %HealthLabel


func update_health(health):
	health_bar.value = health
	health_label.text = "%d / %d" % [health, 100]


func add_skill(skill_info: SkillInfo, slot: Skill.SkillSlot):
	var new_skill_ui = skill_ui.instantiate()
	skills_container.add_child(new_skill_ui)
	registered_skills[slot] = new_skill_ui
	new_skill_ui.create(skill_info)
	#prints(skill_info.skill_name, slot)


func skill_used(slot: Skill.SkillSlot):
	registered_skills[slot].use()
	#print(slot)


func toggle_skill(on: bool, slot: Skill.SkillSlot):
	if on:
		registered_skills[slot].enable()
	else:
		registered_skills[slot].disable()

#func enable_skill(slot: Skill.SkillSlot):
#registered_skills[slot].enable()
#print(slot)
