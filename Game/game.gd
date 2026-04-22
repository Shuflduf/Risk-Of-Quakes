extends Node3D

@export var survivors: Dictionary[String, PackedScene]

func _ready() -> void:
	Lobby.player_loaded.rpc()


@rpc("any_peer", "call_local")
func spawn_player(survivor: String, peer_id: int, spawn_pos: Vector3):
	var new_player = survivors[survivor].instantiate()
	new_player.position = spawn_pos
	add_child(new_player)
	new_player.set_multiplayer_authority(peer_id)
