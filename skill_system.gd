extends Node3D

@export var cam: Camera3D
@export var ray: RayCast3D
@export var player: CharacterBody3D
@export var cam_systems: Node
@export var skills: Dictionary[SkillSlot, Node]

enum SkillSlot {
	PRIMARY,
	SECONDARY,
	UTILITY,
	SPECIAL,
}

func primary():
	call_skill(SkillSlot.PRIMARY)

func secondary():
	call_skill(SkillSlot.SECONDARY)

func utility():
	call_skill(SkillSlot.UTILITY)

func call_skill(skill: SkillSlot):
	var target_skill = skills[skill]
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
