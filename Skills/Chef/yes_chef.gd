extends Skill

signal used

@export var boostable_skills: Array[Skill]

var cooldown = 0.0


func _ready() -> void:
	for skill in boostable_skills:
		skill.revert_abilities.connect(disable_funnies)


func start():
	if cooldown > 0.0:
		return

	for skill in boostable_skills:
		skill.boosted = true
		var new_skill_info = skill.info.duplicate()
		new_skill_info.icon = skill.alternate_icon
		new_skill_info.description = skill.alternate_description
		skill.skill_info_changed.emit(new_skill_info)

	cooldown = INF

	used.emit()
	enabled = false


func disable_funnies():
	enabled = true
	cooldown_started.emit()
	cooldown = info.cooldown
	for skill in boostable_skills:
		skill.boosted = false
		skill.skill_info_changed.emit(skill.info)


func _physics_process(delta: float) -> void:
	cooldown -= delta
