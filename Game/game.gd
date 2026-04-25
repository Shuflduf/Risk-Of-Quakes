extends Node3D

@export var survivors: Dictionary[String, PackedScene]

@rpc("call_local")
func start_game():
	var children_names = get_children().map(func(v: Node): return String(v.name))
	for peer_id in Lobby.players:
		if peer_name(peer_id) in children_names:
			continue
		spawn_peer(peer_id)


func _ready() -> void:
	Lobby.player_loaded.rpc()

	#if !multiplayer.is_server():
	#request_spawn_state.rpc()


#@rpc("any_peer", "call_local")
func spawn_player(survivor: String, peer_id: int, spawn_pos: Node3D):
	var new_player = survivors[survivor].instantiate()
	new_player.position = spawn_pos.position
	new_player.rotation = spawn_pos.rotation
	new_player.set_multiplayer_authority(peer_id)
	new_player.name = peer_name(peer_id)
	add_child(new_player)


func spawn_peer(peer_id: int):
	var survivor = Lobby.players[peer_id]["survivor"]
	var spawn_pos = get_tree().get_nodes_in_group(&"Spawn Point").pick_random()
	spawn_player(survivor, peer_id, spawn_pos)


func peer_name(peer_id):
	return "player_%d" % peer_id

#@rpc("any_peer")
#func request_spawn_state():
#print("doiskd")
#for peer_id in Lobby.players:
#spawn_player.rpc(Lobby.players[peer_id]["survivor"], peer_id, Vector3.ZERO)
