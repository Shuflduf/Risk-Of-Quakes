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
	if username.text.is_empty():
		error_label.text = "Please set a username!"
		return
	
	Lobby.player_info["name"] = username.text
	var err = Lobby.create_game()
	if err:
		if err == Error.ERR_CANT_CREATE:
			error_label.text = "Lobby already created on this network!"
		return

	toggle_server_ui()


func _on_connect_pressed() -> void:
	if username.text.is_empty():
		error_label.text = "Please set a username!"
		return
	
	Lobby.player_info["name"] = username.text
	Lobby.join_game()
	
	get_tree().create_timer(0.5).timeout.connect(func(): error_label.text = "Failed to join lobby!")
	toggle_server_ui()


func toggle_server_ui():
	#connection.hide()
	#lobby_panel.show()
	%StartGame.visible = multiplayer.is_server()
	%MapOption.visible = %StartGame.visible
