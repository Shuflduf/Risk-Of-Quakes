extends HBoxContainer

@onready var player_list: VBoxContainer = %PlayerList
@onready var connection_panel: VBoxContainer = %Connection


func _ready() -> void:
	Lobby.player_connected.connect(_on_player_connected)
	Lobby.player_disconnected.connect(_on_player_disconnected)
	Lobby.server_disconnected.connect(_on_server_disconnected)
	Lobby.survivor_selection_started.connect(_on_survivor_selection_started)
	Lobby.all_survivors_selected.connect(_on_all_survivors_selected)
	Lobby.player_survivor_selected.connect(_on_player_survivor_selected)


func _on_player_connected(_peer_id: int, _player_info: Dictionary):
	update_players_list()


func _on_player_disconnected(_peer_id: int):
	update_players_list()


func _on_server_disconnected():
	go_back_to_connections()


func _on_survivor_selection_started():
	pass


func _on_all_survivors_selected():
	pass


func _on_player_survivor_selected(peer_id: int, survivor: String):
	pass


func update_players_list():
	print(Lobby.players)
	for label in player_list.get_children():
		label.queue_free()
	for id in Lobby.players:
		var new_label = Label.new()
		new_label.text = Lobby.players[id]["name"]
		player_list.add_child(new_label)


func _on_disconnect_pressed() -> void:
	Lobby.remove_multiplayer_peer()
	go_back_to_connections()


func go_back_to_connections():
	hide()
	connection_panel.show()


func _on_start_game_pressed() -> void:
	Lobby.load_game("res://Game/game.tscn")
