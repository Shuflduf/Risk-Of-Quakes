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

	cooldown = INF

	used.emit()
	enabled = false


func disable_funnies():
	enabled = true
	cooldown_started.emit()
	cooldown = info.cooldown
	for skill in boostable_skills:
		skill.boosted = false


func _physics_process(delta: float) -> void:
	cooldown -= delta
