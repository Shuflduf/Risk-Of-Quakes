extends Skill

var cooldown = 0.0
var active = false
var current_direction = Vector3.ZERO
var movement_speed = 0.0

@onready var player: CharacterBody3D = get_parent().player

func use():
	if cooldown > 0.0:
		return
	player.jump_enabled = false
	active = true
	calculate_speed(Utils.flatten_vec(player.velocity).length())
	current_direction = Utils.flatten_vec(player.velocity).normalized()
	cooldown = info.cooldown
	
func _physics_process(delta: float) -> void:
	cooldown -= delta
	if active:
		#player.wish_dir = starting_vel.normalized()
		player.velocity.x = current_direction.x * movement_speed
		player.velocity.z = current_direction.z * movement_speed

func calculate_speed(base_speed: float):
	movement_speed = min(10.0, base_speed) + 5.0
	print(movement_speed)
