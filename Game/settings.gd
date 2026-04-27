extends Node

signal fov_updated(new_fov: float)

const SETTINGS_PATH = "user://settings.json"

var sensitivity = 0.5:
	set(new_val):
		sensitivity = new_val
		save_settings()
var fov = 110.0:
	set(new_val):
		fov = new_val
		fov_updated.emit(new_val)
		save_settings()
var window_mode: DisplayServer.WindowMode = DisplayServer.WindowMode.WINDOW_MODE_WINDOWED:
	set(new_val):
		window_mode = [
			DisplayServer.WindowMode.WINDOW_MODE_WINDOWED,
			DisplayServer.WindowMode.WINDOW_MODE_EXCLUSIVE_FULLSCREEN,
			DisplayServer.WindowMode.WINDOW_MODE_FULLSCREEN,
		][new_val]
		DisplayServer.window_set_mode(window_mode)
		save_settings()

func _ready() -> void:
	var settings_file_content = FileAccess.get_file_as_string(SETTINGS_PATH)
	if settings_file_content:
		var saved_settings = JSON.parse_string(settings_file_content)
		sensitivity = saved_settings["sensitivity"]
		fov = saved_settings["fov"]
		window_mode = saved_settings["window_mode"]


func save_settings():
	var file = FileAccess.open(SETTINGS_PATH, FileAccess.WRITE)
	file.store_string(JSON.stringify({"fov": fov, "sensitivity": sensitivity, "window_mode": window_mode}))
