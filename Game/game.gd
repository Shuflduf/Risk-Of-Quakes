extends Node3D

@export var survivors: Dictionary[String, PackedScene]

@rpc("call_local")
func start_game():
	for peer_id in Lobby.players:
		var survivor = Lobby.players[peer_id]["survivor"]
		var spawn_pos = get_tree().get_nodes_in_group(&"Spawn Point").pick_random().position
		spawn_player(survivor, peer_id, spawn_pos)


func _ready() -> void:
	Lobby.player_loaded.rpc()

	#if !multiplayer.is_server():
	#request_spawn_state.rpc()


#@rpc("any_peer", "call_local")
func spawn_player(survivor: String, peer_id: int, spawn_pos: Vector3):
	var new_player = survivors[survivor].instantiate()
	new_player.position = spawn_pos
	new_player.set_multiplayer_authority(peer_id)
	add_child(new_player, true)

#@rpc("any_peer")
#func request_spawn_state():
#print("doiskd")
#for peer_id in Lobby.players:
#spawn_player.rpc(Lobby.players[peer_id]["survivor"], peer_id, Vector3.ZERO)
