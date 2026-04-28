extends HBoxContainer

@export var player_label: PackedScene

@onready var player_list: VBoxContainer = %PlayerList
@onready var connection_panel: VBoxContainer = %Connection
@onready var survivor_list: VBoxContainer = %SurvivorList
@onready var map_option: OptionButton = %MapOption
@onready var start_game: Button = %StartGame
@onready var loading_label: Label = %LoadingLabel


func _ready() -> void:
	Lobby.player_connected.connect(_on_player_connected)
	Lobby.player_disconnected.connect(_on_player_disconnected)
	Lobby.server_disconnected.connect(_on_server_disconnected)
	Lobby.survivor_selection_started.connect(_on_survivor_selection_started)
	Lobby.loading_game_started.connect(_on_loading_game_started)
	Lobby.player_survivor_selected.connect(_on_other_player_survivor_selected)
	survivor_list.survivor_selected.connect(_on_survivor_selected)


func _on_player_connected(_peer_id: int, _player_info: Dictionary):
	if Lobby.singleplayer:
		return
	
	show()
	connection_panel.hide()
	update_players_list()

	if Lobby.current_state == Lobby.GameState.CHOOSING_SURVIVORS:
		survivor_list.show()
	elif Lobby.current_state == Lobby.GameState.IN_GAME:
		Lobby.error_message = "Game in progress on this network!"
		Lobby.remove_multiplayer_peer()


func _on_player_disconnected(_peer_id: int):
	update_players_list()


func _on_server_disconnected():
	go_back_to_connections()


func _on_survivor_selection_started():
	survivor_list.show()
	start_game.disabled = true
	map_option.disabled = true


func _on_loading_game_started():
	loading_label.text = "Loading, please wait."


func _on_other_player_survivor_selected(peer_id: int, _survivor: String):
	if Lobby.singleplayer:
		return
	
	var names = player_list.get_children()
	names[names.find_custom(func(v): return v.text == Lobby.players[peer_id]["name"])].selected = true


func _on_survivor_selected(survivor: String):
	if Lobby.current_state == Lobby.GameState.CHOOSING_SURVIVORS:
		Lobby.select_survivor.rpc(survivor)
	#elif Lobby.current_state == Lobby.GameState.IN_GAME:
	#Lobby.error_message = "Game in progress."
	#Lobby.remove_multiplayer_peer()
	#go_back_to_connections()


func update_players_list():
	for label in player_list.get_children():
		label.queue_free()
	for id in Lobby.players:
		var new_label = player_label.instantiate()
		new_label.text = Lobby.players[id]["name"]
		player_list.add_child(new_label)


func _on_disconnect_pressed() -> void:
	Lobby.remove_multiplayer_peer()


func go_back_to_connections():
	hide()
	connection_panel.show()


func _on_start_game_pressed() -> void:
	Lobby.start_survivor_selection.rpc()


func _on_map_option_item_selected(index: int) -> void:
	Lobby.map_scene = Lobby.MAPS[index]


func _on_copy_ip_pressed() -> void:
	print(IP.get_local_addresses())
	var local_address = ""
	for ip in IP.get_local_addresses():
		if ip.count(".") == 3 and ip.begins_with("192.168"):
			local_address = "%s:%d" % [ip, Lobby.port]
			break

	DisplayServer.clipboard_set(local_address)
