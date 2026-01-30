extends VBoxContainer

@onready var player_list: VBoxContainer = $PlayerList
@onready var connection: VBoxContainer = $"../Connection"
@onready var main_menu: Control = $".."


func update_players(players: Dictionary):
	print(players)
	for child in player_list.get_children():
		child.queue_free()

	for player in players:
		var new_label = Label.new().duplicate()
		new_label.text = players[player]
		player_list.add_child(new_label)


func _on_disconnect_pressed() -> void:
	#main_menu.players.erase(multiplayer.get_unique_id())
	multiplayer.multiplayer_peer = OfflineMultiplayerPeer.new()
	hide()
	connection.show()
