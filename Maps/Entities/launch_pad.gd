extends Node3D

@export var target: Marker3D

@onready var area: Area3D = $Area


func _ready() -> void:
	area.body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node3D):
	if body is CharacterBody3D and target:
		body.fly_to(target.global_position)
		
