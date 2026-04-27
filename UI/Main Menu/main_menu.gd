extends Control

@onready var username: LineEdit = %Username
@onready var connection: VBoxContainer = $Connection
@onready var lobby_panel: HBoxContainer = $Lobby
@onready var error_label: Label = %ErrorLabel


func _ready() -> void:
	if OS.get_cmdline_args().size() > 2:
		username.text = OS.get_cmdline_args()[2]
	if Lobby.error_message:
		error_label.text = Lobby.error_message


func _on_host_pressed() -> void:
	Lobby.player_info["name"] = username.text
	var err = Lobby.create_game()
	if err:
		if err == Error.ERR_CANT_CREATE:
			error_label.text = "Lobby already created on this network!"
		return

	transition_to_lobby()


func _on_connect_pressed() -> void:
	Lobby.player_info["name"] = username.text
	Lobby.join_game()

	transition_to_lobby()


func transition_to_lobby():
	#connection.hide()
	#lobby_panel.show()
	%StartGame.visible = multiplayer.is_server()
	%MapOption.visible = %StartGame.visible
