extends Node3D

const SPINE_INDEX = 0
@export var hand_handles: Array[Marker3D]
@export var skeleton: Skeleton3D

@onready var og_hand_pos: Array = hand_handles.map(func(hand): return hand.position)

#@onready var right_hand: Marker3D = $metarig/Skeleton3D/spine_004/RightHand
#@onready var right_hand_og_trans = right_hand.transform

func set_spine_angle(new_angle: float):
	skeleton.set_bone_pose_rotation(SPINE_INDEX, Quaternion.from_euler(Vector3(new_angle, 0.0, 0.0)))

func connect_skills(_skills: Dictionary[Skill.SkillSlot, Skill]):
	pass
