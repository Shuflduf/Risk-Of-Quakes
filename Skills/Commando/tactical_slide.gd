extends Skill

signal used

@export var dip_curve: Curve

@onready var cam: Camera3D = get_parent().cam
@onready var player: CharacterBody3D = get_parent().player
@onready var cam_offset = get_parent().cam_systems.get_node_or_null(^"Offset") if get_parent().cam_systems else null

var current_cooldown = 0.0
var slide_initiated = false

func _physics_process(delta: float) -> void:
	current_cooldown -= delta
	
	if cam_offset and slide_initiated and (info.cooldown - current_cooldown < dip_curve.max_domain):
		cam_offset.offset.y = dip_curve.sample_baked(info.cooldown - current_cooldown)
	
	if info.cooldown - current_cooldown + 0.5 > dip_curve.max_domain and slide_initiated:
		player.jump_enabled = true

	
func use():
	if current_cooldown > 0.0:
		return
		
	current_cooldown = info.cooldown
	var boost_dir = Vector3(-sin(cam.rotation.y), 0.0, -cos(cam.rotation.y)) if player.wish_dir.is_zero_approx() else player.wish_dir
	if player.is_on_floor():
		player.velocity += boost_dir * 15.0
		player.jump_enabled = false
		slide_initiated = true
	else:
		var speed = max(6.0, Vector3(player.velocity.x, 0.0, player.velocity.z).length())
		player.velocity = boost_dir * speed
		player.velocity.y = min(speed, 8.0)
		slide_initiated = false
	used.emit()
	
