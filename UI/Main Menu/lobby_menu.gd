extends HBoxContainer

@export var player_label: PackedScene

@onready var player_list: VBoxContainer = %PlayerList
@onready var connection_panel: VBoxContainer = %Connection
@onready var survivor_list: VBoxContainer = %SurvivorList


func _ready() -> void:
	Lobby.player_connected.connect(_on_player_connected)
	Lobby.player_disconnected.connect(_on_player_disconnected)
	Lobby.server_disconnected.connect(_on_server_disconnected)
	Lobby.survivor_selection_started.connect(_on_survivor_selection_started)
	Lobby.all_survivors_selected.connect(_on_all_survivors_selected)
	Lobby.player_survivor_selected.connect(_on_player_survivor_selected)
	survivor_list.survivor_selected.connect(Lobby.select_survivor.rpc)


func _on_player_connected(_peer_id: int, _player_info: Dictionary):
	update_players_list()


func _on_player_disconnected(_peer_id: int):
	update_players_list()


func _on_server_disconnected():
	go_back_to_connections()


func _on_survivor_selection_started():
	survivor_list.show()
	%StartGame.disabled = true


func _on_all_survivors_selected():
	pass


func _on_player_survivor_selected(peer_id: int, _survivor: String):
	var names = player_list.get_children()
	names[names.find_custom(func(v): return v.text == Lobby.players[peer_id]["name"])].selected = true


func update_players_list():
	for label in player_list.get_children():
		label.queue_free()
	for id in Lobby.players:
		var new_label = player_label.instantiate()
		new_label.text = Lobby.players[id]["name"]
		player_list.add_child(new_label)


func _on_disconnect_pressed() -> void:
	Lobby.remove_multiplayer_peer()
	go_back_to_connections()


func go_back_to_connections():
	hide()
	connection_panel.show()


func _on_start_game_pressed() -> void:
	Lobby.start_survivor_selection.rpc()
