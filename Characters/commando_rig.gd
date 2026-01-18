extends Node3D

const SPINE_INDEX = 1
@export var hand_handles: Array[Marker3D]

@onready var skeleton: Skeleton3D = $metarig/Skeleton3D
@onready var og_hand_pos: Array = hand_handles.map(func(hand): return hand.position)

#@onready var right_hand: Marker3D = $metarig/Skeleton3D/spine_004/RightHand
#@onready var right_hand_og_trans = right_hand.transform


func connect_skills(skills: Dictionary[Skill.SkillSlot, Skill]):
	skills[Skill.SkillSlot.PRIMARY].used.connect(primary)
	skills[Skill.SkillSlot.SECONDARY].used.connect(secondary)


func set_spine_angle(new_angle: float):
	skeleton.set_bone_pose_rotation(
		SPINE_INDEX, Quaternion.from_euler(Vector3(new_angle, 0.0, 0.0))
	)


func primary(index: int):
	var target_hand = hand_handles[index]
	var og_pos = og_hand_pos[index]
	var tween = get_tree().create_tween().set_ease(Tween.EASE_OUT)
	tween.tween_property(target_hand, ^"position:z", og_pos.z - 0.1, 0.05).set_trans(
		Tween.TRANS_EXPO
	)
	tween.tween_property(target_hand, ^"position:z", og_pos.z, 0.6).set_trans(Tween.TRANS_CUBIC)


func secondary(started: bool):
	return
	@warning_ignore("unreachable_code")
	if started:
		for i in hand_handles.size():
			var hand: Marker3D = hand_handles[i]
			var og_pos = og_hand_pos[i]
			var left_side = i % 2 == 0
			var side_mult = 1.0 if left_side else -1.0
			#gun.position.x = 0.2 * side_mult

			var tween = get_tree().create_tween().set_ease(Tween.EASE_OUT)
			tween.tween_property(hand, ^"position:x", og_pos.x + (0.08 * side_mult), 0.4).set_trans(
				Tween.TRANS_BACK
			)
			tween.parallel().tween_property(hand, ^"position:z", og_pos.z - 0.1, 0.4).set_trans(
				Tween.TRANS_BACK
			)
			tween.tween_interval(0.1)
			tween.tween_callback($metarig/Skeleton3D/TwoBoneIK3D.set_active.bind(false))
			tween.tween_interval(0.1)
			tween.tween_callback($metarig/Skeleton3D/TwoBoneIK3D.set_active.bind(true))
