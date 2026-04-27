extends Node

signal survivor_selection_started
signal loading_game_started
signal player_survivor_selected(peer_id: int, survivor: String)
signal leaderboard_updated

signal player_connected(peer_id: int, player_info: Dictionary)
signal player_disconnected(peer_id: int)
signal server_disconnected

enum GameState {
	WAITING_FOR_PLAYERS,
	CHOOSING_SURVIVORS,
	IN_GAME,
}

const PORT = 7000
const DEFAULT_SERVER_IP = "127.0.0.1"
const MAX_CONNECTIONS = 20
const GAME_SCENE = "res://Game/game.tscn"
const MAIN_MENU_SCENE = "res://UI/Main Menu/main_menu.tscn"
const BASE_PLAYER_INFO = {"name": "Name", "survivor": "Survivor", "kills": 0, "deaths": 0}
const MAPS = ["res://Maps/bulwarks.tscn", "res://Maps/skirmish.tscn"]

var players = {}
var error_message = ""
var player_info = BASE_PLAYER_INFO.duplicate()
var players_loaded = 0
var current_state: GameState = GameState.WAITING_FOR_PLAYERS
var map_scene = MAPS[0]
var status_label: Label


func _ready():
	multiplayer.peer_connected.connect(_on_player_connected)
	multiplayer.peer_disconnected.connect(_on_player_disconnected)
	multiplayer.connected_to_server.connect(_on_connected_ok)
	multiplayer.connection_failed.connect(_on_connected_fail)
	multiplayer.server_disconnected.connect(_on_server_disconnected)
	status_label = Label.new()
	status_label.z_index = 1000
	add_child(status_label)


func join_game(address = DEFAULT_SERVER_IP):
	var peer = ENetMultiplayerPeer.new()
	var error = peer.create_client(address, PORT)
	if error:
		return error

	multiplayer.multiplayer_peer = peer


func create_game():
	var peer = ENetMultiplayerPeer.new()
	var error = peer.create_server(PORT, MAX_CONNECTIONS)
	if error:
		return error

	multiplayer.multiplayer_peer = peer

	players[1] = player_info
	player_connected.emit(1, player_info)


func remove_multiplayer_peer():
	players_loaded = 0
	current_state = GameState.WAITING_FOR_PLAYERS
	multiplayer.multiplayer_peer = OfflineMultiplayerPeer.new()
	players.clear()
	player_info = BASE_PLAYER_INFO.duplicate()
	get_tree().change_scene_to_file(MAIN_MENU_SCENE)


@rpc("call_local")
func load_game(game_scene_path):
	loading_game_started.emit()
	status_label.text = "The game is loading. Please be patient."
	await get_tree().process_frame
	await get_tree().process_frame
	current_state = Lobby.GameState.IN_GAME
	get_tree().change_scene_to_file(game_scene_path)


@rpc("any_peer", "call_local")
func player_loaded():
	if multiplayer.is_server():
		players_loaded += 1
		if players_loaded == players.size():
			$/root/Game.start_game.rpc(map_scene)


func _on_player_connected(id):
	_register_player.rpc_id(id, player_info, current_state)


@rpc("any_peer")
func _register_player(new_player_info, current_server_state: GameState):
	var new_player_id = multiplayer.get_remote_sender_id()
	players[new_player_id] = new_player_info
	if multiplayer.get_remote_sender_id() == 1:
		current_state = current_server_state
	player_connected.emit(new_player_id, new_player_info)


func _on_player_disconnected(id):
	players.erase(id)
	player_disconnected.emit(id)


func _on_connected_ok():
	var peer_id = multiplayer.get_unique_id()
	players[peer_id] = player_info
	#player_connected.emit(peer_id, player_info)


func _on_connected_fail():
	error_message = "Connection failed!"
	remove_multiplayer_peer()


func _on_server_disconnected():
	players.clear()
	server_disconnected.emit()
	error_message = "Disconnected from server!"
	remove_multiplayer_peer()


@rpc("call_local")
func start_survivor_selection():
	current_state = GameState.CHOOSING_SURVIVORS
	survivor_selection_started.emit()


@rpc("any_peer", "call_local")
func select_survivor(survivor: String):
	var peer_id = multiplayer.get_remote_sender_id()
	players[peer_id]["survivor"] = survivor
	player_survivor_selected.emit(peer_id, survivor)

	if multiplayer.is_server():
		var ready_players = players.values().reduce(
			func(accum, v): return accum + (1 if v["survivor"] != "Survivor" else 0), 0
		)
		if ready_players == players.size():
			load_game.rpc(GAME_SCENE)


@rpc("any_peer", "call_local")
func join_game_late(survivor: String):
	var peer_id = multiplayer.get_remote_sender_id()
	players[peer_id]["survivor"] = survivor
	# prints(multiplayer.get_unique_id(), survivor)
	if peer_id == multiplayer.get_unique_id():
		load_game(GAME_SCENE)


func sync_leaderboard():
	leaderboard_updated.emit()

#@rpc("call_local")
#func start_game():
#for peer_id in players:
#var survivor = players[peer_id]["survivor"]
#var spawn_pos = get_tree().get_nodes_in_group(&"Spawn Point").pick_random().position
#$/root/Game.spawn_player(survivor, peer_id, spawn_pos)
