extends VBoxContainer

signal survivor_selected(survivor: String)


func _ready() -> void:
	for child in get_children():
		if child is Button:
			child.pressed.connect(survivor_selected.emit.bind(child.text))
