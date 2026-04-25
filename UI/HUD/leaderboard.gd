class_name Leaderboard
extends PanelContainer

var entries: Array[LeaderboardEntry] = []

@onready var username_container: VBoxContainer = %UsernameContainer
@onready var survivor_container: VBoxContainer = %SurvivorContainer
@onready var kills_container: VBoxContainer = %KillsContainer
@onready var deaths_container: VBoxContainer = %DeathsContainer

@onready var data_columns: Dictionary[StringName, VBoxContainer] = {
	&"username": username_container,
	&"survivor": survivor_container,
	&"kills": kills_container,
	&"deaths": deaths_container,
}


func rebuild():
	for column in [username_container, survivor_container, kills_container, deaths_container]:
		clear_column(column)
	for data in data_columns:
		populate_column(data)


func clear_column(column: VBoxContainer):
	for child in column.get_children():
		
		if child.name == &"Header":
			continue

		child.queue_free()


func populate_column(data: StringName):
	var column = data_columns[data]
	for entry in entries:
		var new_label = Label.new()
		new_label.text = str(entry.get(data))
		column.add_child(new_label)


class LeaderboardEntry:
	var username: String
	var survivor: String
	var kills: int
	var deaths: int
