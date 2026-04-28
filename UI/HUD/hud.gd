extends Control

signal disconnected

@export var skill_ui: PackedScene

var registered_skills: Dictionary[Skill.SkillSlot, Node]
var remaining_respawn_time = 0.0

@onready var skills_container: HBoxContainer = %SkillsContainer
@onready var health_bar: ProgressBar = %HealthBar
@onready var health_label: Label = %HealthLabel
@onready var death_container: VBoxContainer = %DeathContainer
@onready var death_message: Label = %DeathMessage
@onready var respawn_label: Label = %RespawnLabel
@onready var skill_info_container: PanelContainer = %SkillInfoContainer
@onready var skill_title: Label = %SkillTitle
@onready var skill_description: RichTextLabel = %SkillDescription
@onready var leaderboard: Leaderboard = %Leaderboard
@onready var pause_screen: MarginContainer = %PauseScreen
@onready var help_text: VBoxContainer = %HelpText
@onready var settings_menu: MarginContainer = %Settings

func _ready() -> void:
	settings_menu.disconnect_button.pressed.connect(disconnected.emit)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed(&"show_leaderboard"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		leaderboard.show()
	elif event.is_action_released(&"show_leaderboard"):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		leaderboard.hide()

	if event.is_action_pressed(&"pause"):
		pause_screen.visible = not pause_screen.visible
		
	if event.is_action_pressed(&"hide_help_text"):
		help_text.visible = !help_text.visible


func show_skill_info(skill_slot: Skill.SkillSlot):
	var skill_info = registered_skills[skill_slot].active_skill_info
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


func change_skill_info(new_info: SkillInfo, slot: Skill.SkillSlot):
	registered_skills[slot].create(new_info, slot)


func update_health(health: int):
	health_bar.value = health
	health_label.text = "%d / %d" % [health, 100]


func add_skill(skill_info: SkillInfo, slot: Skill.SkillSlot):
	var new_skill_ui = skill_ui.instantiate()
	skills_container.add_child(new_skill_ui)
	registered_skills[slot] = new_skill_ui
	new_skill_ui.create(skill_info, slot)
	new_skill_ui.mouse_entered.connect(show_skill_info.bind(slot))
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


func _process(delta: float) -> void:
	if pause_screen.visible:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	if remaining_respawn_time > 0.0:
		remaining_respawn_time -= delta
		respawn_label.text = "Respawning in %d" % remaining_respawn_time
		if remaining_respawn_time <= 0.0:
			death_container.hide()


func reconstruct_leaderboard():
	leaderboard.entries = []
	for i in Lobby.players:
		var player = Lobby.players[i]
		var new_entry = Leaderboard.LeaderboardEntry.new()
		new_entry.username = player.name
		new_entry.survivor = player.survivor
		new_entry.kills = player.kills
		new_entry.deaths = player.deaths
		#prints(new_entry.username, new_entry.deaths)
		leaderboard.entries.append(new_entry)
	leaderboard.rebuild()


#func enable_skill(slot: Skill.SkillSlot):
#registered_skills[slot].enable()
#print(slot)


func _on_disconnect_pressed() -> void:
	disconnected.emit()
