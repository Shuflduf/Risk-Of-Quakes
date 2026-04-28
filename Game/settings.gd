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
var vsync = true:
	set(new_val):
		vsync = new_val
		DisplayServer.window_set_vsync_mode(
			DisplayServer.VSYNC_ENABLED if vsync else DisplayServer.VSYNC_DISABLED
		)
		save_settings()
var gui_scale = 1.0:
	set(new_val):
		gui_scale = new_val
		get_window().content_scale_factor = gui_scale
		save_settings()

const ALL_SETTINGS = [&"sensitivity", &"fov", &"window_mode", &"vsync", &"gui_scale"]

func _ready() -> void:
	var settings_file_content = FileAccess.get_file_as_string(SETTINGS_PATH)
	if settings_file_content:
		var saved_settings: Dictionary = JSON.parse_string(settings_file_content)
		for setting in ALL_SETTINGS:
			if saved_settings.has(setting):
				set(setting, saved_settings[setting])


func save_settings():
	var file = FileAccess.open(SETTINGS_PATH, FileAccess.WRITE)
	var data = {}
	for setting in ALL_SETTINGS:
		data[setting] = get(setting)
		
	file.store_string(JSON.stringify(data))
