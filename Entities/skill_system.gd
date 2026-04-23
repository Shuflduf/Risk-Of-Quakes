extends Node3D

@export var special_pickups_enabled = false

@export var cam: Camera3D
@export var cam_systems: CameraSystemManager
@export var skill_list: Dictionary[Skill.SkillSlot, Skill]
@export var player: CharacterBody3D


func _ready() -> void:
	var target_skill = skill_list.get(Skill.SkillSlot.SPECIAL)
	if target_skill and special_pickups_enabled:
		target_skill.enabled = false
		target_skill.cooldown_started.connect(func(): target_skill.enabled = false)


func primary(start: bool):
	call_skill(Skill.SkillSlot.PRIMARY, start)


func secondary(start: bool):
	call_skill(Skill.SkillSlot.SECONDARY, start)


func utility(start: bool):
	call_skill(Skill.SkillSlot.UTILITY, start)


func special(start: bool):
	call_skill(Skill.SkillSlot.SPECIAL, start)


func call_skill(skill: Skill.SkillSlot, start):
	if start:
		start_skill.rpc(skill)
	else:
		finish_skill.rpc(skill)


func give_special():
	if !special_pickups_enabled:
		return
	var target_skill = skill_list[Skill.SkillSlot.SPECIAL]
	if target_skill:
		target_skill.enabled = true
		target_skill.cooldown = 0.0


@rpc("any_peer", "call_local")
func start_skill(skill: Skill.SkillSlot):
	var target_skill = skill_list[skill]
	if target_skill.enabled:
		target_skill.start()

@rpc("any_peer", "call_local")
func finish_skill(skill: Skill.SkillSlot):
	var target_skill = skill_list[skill]
	target_skill.finish()

#func _ready() -> void:
#for weapon in get_children():
#var follow_cam_node = weapon.get_node_or_null(^"FollowCamera")
#if follow_cam_node:
#follow_cam_node.cam = cam
#var hitscan_node = weapon.get_node_or_null(^"Hitscan")
##var cam_raycast =
#if hitscan_node:
#hitscan_node.ray = ray
