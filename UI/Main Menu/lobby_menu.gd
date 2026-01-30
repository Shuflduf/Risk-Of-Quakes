extends VBoxContainer

@onready var player_list: VBoxContainer = $PlayerList
@onready var connection: VBoxContainer = $"../Connection"


func _ready() -> void:
	Lobby.player_connected.connect(_on_player_connected)
	Lobby.player_disconnected.connect(_on_player_disconnected)
	Lobby.server_disconnected.connect(_on_server_disconnected)


func _on_player_connected(_peer_id: int, _player_info: Dictionary):
	update_players_list()


func _on_player_disconnected(_peer_id: int):
	update_players_list()


func _on_server_disconnected():
	go_back_to_connections()


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
	connection.show()
