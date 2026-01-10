extends Node

@export var ability_cooldown = 1.0
@export var dip_curve: Curve

var current_cooldown = 0.0
@onready var cam: Camera3D = get_parent().cam
@onready var player: CharacterBody3D = get_parent().player
@onready var cam_offset = get_parent().cam_systems.get_node_or_null(^"Offset") if get_parent().cam_systems else null

var slide_initiated = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	current_cooldown -= delta
	if Input.is_action_just_pressed(&"utility") and current_cooldown <= 0.0:
		current_cooldown = ability_cooldown
		var boost_dir = Vector3(-sin(cam.rotation.y), 0.0, -cos(cam.rotation.y)) if player.wish_dir.is_zero_approx() else player.wish_dir
		if player.is_on_floor():
			player.velocity += boost_dir * 15.0
			player.jump_enabled = false
			slide_initiated = true
		else:
			var speed = max(6.0, Vector3(player.velocity.x, 0.0, player.velocity.z).length())
			print(speed)
			player.velocity = boost_dir * speed
			player.velocity.y = min(speed, 8.0)
			slide_initiated = false
	
	if cam_offset and slide_initiated and (ability_cooldown - current_cooldown < dip_curve.max_domain):
		cam_offset.offset.y = dip_curve.sample_baked(ability_cooldown - current_cooldown)
	
	if ability_cooldown - current_cooldown + 0.5 > dip_curve.max_domain and slide_initiated:
		player.jump_enabled = true
