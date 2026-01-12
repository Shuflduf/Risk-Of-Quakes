extends Node3D

@export var cam: Camera3D
@export var ray: RayCast3D
@export var player: CharacterBody3D
@export var cam_systems: Node
@export var skill_list: Dictionary[Skill.SkillSlot, Node]

func primary():
	call_skill(Skill.SkillSlot.PRIMARY)

func secondary():
	call_skill(Skill.SkillSlot.SECONDARY)

func utility():
	call_skill(Skill.SkillSlot.UTILITY)

func special():
	call_skill(Skill.SkillSlot.SPECIAL)


func call_skill(skill: Skill.SkillSlot):
	var target_skill = skill_list[skill]
	if target_skill:
		target_skill.use()

#func _ready() -> void:
	#for weapon in get_children():
		#var follow_cam_node = weapon.get_node_or_null(^"FollowCamera")
		#if follow_cam_node:
			#follow_cam_node.cam = cam
		#var hitscan_node = weapon.get_node_or_null(^"Hitscan")
		##var cam_raycast = 
		#if hitscan_node:
			#hitscan_node.ray = ray
