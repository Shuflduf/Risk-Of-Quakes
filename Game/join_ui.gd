extends Control

@export var survivors: Array[PackedScene]
@onready var game: Node3D = $".."


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass  # Replace with function body.


func _on_button_pressed() -> void:
	game.join_as(survivors[0])
	hide()


func _on_button_2_pressed() -> void:
	game.join_as(survivors[1])
	hide()
