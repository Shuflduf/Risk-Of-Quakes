extends Node3D

@export var survivors: Dictionary[String, PackedScene]

func _ready() -> void:
	Lobby.player_loaded.rpc()

@rpc("call_local")
func start_game():
	for peer_id in Lobby.players:
		print("peer_id: ", peer_id, " survivor: ", Lobby.players[peer_id].get("survivor", "NOT SET"))
		join_as(survivors[Lobby.players[peer_id]["survivor"]], peer_id)

func join_as(survivor: PackedScene, peer_id):
	var spawn_pos = get_tree().get_nodes_in_group(&"Spawn Point").pick_random()
	var new_player = survivor.instantiate()
	new_player.position = spawn_pos.position
	add_child(new_player)
	new_player.set_multiplayer_authority(peer_id)
