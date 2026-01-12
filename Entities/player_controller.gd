extends Node

@export var cam: Camera3D
@export var skills: Node3D
@export var cam_systems: CameraSystemManager
@export var hud: Control

@onready var player: CharacterBody3D = get_parent()
@onready var skin: Node3D = $"../Skin"

func _ready() -> void:
	cam_systems.default_cam_transform = cam_systems.default_cam_transform.rotated(Vector3.UP, player.rotation.y)
	player.rotation.y = 0.0
	
	for slot in skills.skill_list:
		var target_skill = skills.skill_list[slot]
		hud.add_skill(target_skill.info, slot)
		target_skill.used.connect(func(..._args): hud.skill_used(slot))
		target_skill.enabled_changed.connect(func(): hud.toggle_skill(target_skill.enabled, slot))
	skills.skill_list[Skill.SkillSlot.PRIMARY].used.connect(skin.primary)
	skills.skill_list[Skill.SkillSlot.SECONDARY].used.connect(skin.secondary)


func _physics_process(_delta: float) -> void:
	var input_dir = Input.get_vector(&"left", &"right", &"forward", &"backward").rotated(-cam.rotation.y)
	player.wish_dir = Vector3(input_dir.x, 0.0, input_dir.y)
	if Input.is_action_pressed(&"jump") and player.is_on_floor() and player.jump_enabled:
		player.wish_jump = true
	
	if Input.is_action_pressed(&"primary"):
		skills.primary()
		
	if Input.is_action_pressed(&"secondary"):
		skills.secondary()
	
	if Input.is_action_pressed(&"utility"):
		skills.utility()
	
	if Input.is_action_pressed(&"special"):
		skills.special()
	
	skin.visible = get_viewport().get_camera_3d() != cam
	skills.visible = !skin.visible
	skin.rotation.y = cam.rotation.y
	skin.set_spine_angle(-cam.rotation.x)
