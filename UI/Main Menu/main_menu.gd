extends Control

@onready var username: LineEdit = $Connection/Username
@onready var connection: VBoxContainer = $Connection
@onready var lobby: VBoxContainer = $Lobby


func _on_host_pressed() -> void:
	Lobby.player_info["name"] = username.text
	Lobby.create_game()

	transition_to_lobby()


func _on_connect_pressed() -> void:
	Lobby.player_info["name"] = username.text
	Lobby.join_game()

	transition_to_lobby()


func transition_to_lobby():
	connection.hide()
	lobby.show()
	$Lobby/StartGame.visible = multiplayer.is_server()
