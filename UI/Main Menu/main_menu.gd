extends Control

const IP_ADDRESS = "127.0.0.1"

var players = {}

@onready var port: SpinBox = $Connection/Port
@onready var username: LineEdit = $Connection/Username
@onready var connection: VBoxContainer = $Connection
@onready var lobby: VBoxContainer = $Lobby


func _ready():
	multiplayer.peer_connected.connect(_on_player_connected)
	multiplayer.peer_disconnected.connect(_on_player_disconnected)
	multiplayer.server_disconnected.connect(_on_server_disconnected)


func _on_host_pressed() -> void:
	var peer = ENetMultiplayerPeer.new()
	peer.create_server(int(port.value))
	multiplayer.multiplayer_peer = peer
	players[multiplayer.get_unique_id()] = username.text
	transition_to_lobby()


func _on_connect_pressed() -> void:
	var peer = ENetMultiplayerPeer.new()
	var err = peer.create_client(IP_ADDRESS, int(port.value))
	print(err)
	multiplayer.multiplayer_peer = peer
	players.clear()
	players[multiplayer.get_unique_id()] = username.text
	transition_to_lobby()


func _on_player_connected(id):
	prints(multiplayer.get_unique_id(), id)
	_register_player.rpc_id(id, username.text)


func _on_player_disconnected(id):
	players.erase(id)
	lobby.update_players(players)


func _on_server_disconnected():
	multiplayer.multiplayer_peer = OfflineMultiplayerPeer.new()
	players.clear()
	lobby.hide()
	connection.show()


@rpc("any_peer", "reliable")
func _register_player(new_player_info):
	players[multiplayer.get_remote_sender_id()] = new_player_info
	lobby.update_players(players)


func transition_to_lobby():
	connection.hide()
	lobby.show()
	lobby.update_players(players)
