extends Node3D

@export var survivors: Dictionary[String, PackedScene]


func _ready() -> void:
	Lobby.player_loaded.rpc()

	#if !multiplayer.is_server():
		#print("sljkd", multiplayer.get_unique_id())
		#request_spawn_state.rpc()


@rpc("any_peer", "call_local")
func spawn_player(survivor: String, peer_id: int, spawn_pos: Vector3):
	var new_player = survivors[survivor].instantiate()
	new_player.position = spawn_pos
	add_child(new_player, true)
	new_player.set_multiplayer_authority(peer_id)


#@rpc("any_peer")
#func request_spawn_state():
	#print("doiskd")
	#for peer_id in Lobby.players:
		#spawn_player.rpc(Lobby.players[peer_id]["survivor"], peer_id, Vector3.ZERO)
