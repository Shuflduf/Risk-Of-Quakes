extends HBoxContainer

@export var player_label: PackedScene

@onready var survivor_list: VBoxContainer = %SurvivorList
@onready var map_option: OptionButton = %MapOption
@onready var start_game: Button = %StartGame
@onready var loading_label: Label = %LoadingLabel


func _ready() -> void:
	Lobby.create_game()
	
	Lobby.survivor_selection_started.connect(_on_survivor_selection_started)
	Lobby.loading_game_started.connect(_on_loading_game_started)
	Lobby.player_survivor_selected.connect(_on_player_survivor_selected)
	
	survivor_list.survivor_selected.connect(_on_survivor_selected)


func _on_survivor_selection_started():
	survivor_list.show()
	start_game.disabled = true
	map_option.disabled = true


func _on_loading_game_started():
	loading_label.text = "Loading, please wait."


func _on_player_survivor_selected(_peer_id: int, _survivor: String):
	pass


func _on_survivor_selected(survivor: String):
	if Lobby.current_state == Lobby.GameState.CHOOSING_SURVIVORS:
		Lobby.select_survivor.rpc(survivor)


func _on_start_game_pressed() -> void:
	Lobby.start_survivor_selection.rpc()


func _on_map_option_item_selected(index: int) -> void:
	Lobby.map_scene = Lobby.MAPS[index]


func _on_go_back_pressed() -> void:
	Lobby.remove_multiplayer_peer()
