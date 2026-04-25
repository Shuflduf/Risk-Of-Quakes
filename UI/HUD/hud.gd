extends Control

@export var skill_ui: PackedScene

var registered_skills: Dictionary[Skill.SkillSlot, Node]

@onready var skills_container: HBoxContainer = %SkillsContainer
@onready var health_bar: ProgressBar = %HealthBar
@onready var health_label: Label = %HealthLabel
@onready var death_container: VBoxContainer = %DeathContainer
@onready var death_message: Label = %DeathMessage
@onready var respawn_label: Label = %RespawnLabel
@onready var skill_info_container: PanelContainer = %SkillInfoContainer
@onready var skill_title: Label = %SkillTitle
@onready var skill_description: Label = %SkillDescription

var remaining_respawn_time = 0.0

func show_skill_info(skill_info: SkillInfo):
	print(skill_info.skill_name)
	skill_info_container.show()
	skill_title.text = skill_info.skill_name
	skill_description.text = skill_info.description
	
func hide_skill_info():
	skill_info_container.hide()

func respawn(respawn_seconds: float):
	if death_container.visible:
		return
		
	death_container.show()
	death_message.text = DeathMessages.MESSAGES.pick_random()
	remaining_respawn_time = respawn_seconds


func change_icon(new_icon: Texture2D, slot: Skill.SkillSlot):
	registered_skills[slot].change_icon(new_icon)

func update_health(health: int):
	health_bar.value = health
	health_label.text = "%d / %d" % [health, 100]


func add_skill(skill_info: SkillInfo, slot: Skill.SkillSlot):
	var new_skill_ui = skill_ui.instantiate()
	skills_container.add_child(new_skill_ui)
	registered_skills[slot] = new_skill_ui
	new_skill_ui.create(skill_info)
	new_skill_ui.mouse_entered.connect(show_skill_info.bind(skill_info))
	new_skill_ui.mouse_exited.connect(hide_skill_info)

	#prints(skill_info.skill_name, slot)


func skill_used(slot: Skill.SkillSlot):
	registered_skills[slot].use()
	#print(slot)


func toggle_skill(on: bool, slot: Skill.SkillSlot):
	if on:
		registered_skills[slot].enable()
	else:
		registered_skills[slot].disable()

func _physics_process(delta: float) -> void:
	if remaining_respawn_time > 0.0:
		remaining_respawn_time -= delta
		respawn_label.text = "Respawning in %d" % remaining_respawn_time
		if remaining_respawn_time <= 0.0:
			death_container.hide()

#func enable_skill(slot: Skill.SkillSlot):
#registered_skills[slot].enable()
#print(slot)
