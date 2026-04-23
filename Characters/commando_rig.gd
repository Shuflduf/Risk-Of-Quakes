extends Node3D

const SPINE_INDEX = 1
@export var hand_handles: Array[Marker3D]
@export var phase_round_handles: Array[Marker3D]

var tweens: Array[Tween] = []

@onready var skeleton: Skeleton3D = $metarig/Skeleton3D
@onready var og_hand_pos: Array = hand_handles.map(func(hand): return hand.position)



func connect_skills(skills: Dictionary[Skill.SkillSlot, Skill]):
	skills[Skill.SkillSlot.PRIMARY].used.connect(primary)
	skills[Skill.SkillSlot.SECONDARY].used.connect(secondary)


func set_spine_angle(new_angle: float):
	skeleton.set_bone_pose_rotation(
		SPINE_INDEX, Quaternion.from_euler(Vector3(snappedf(new_angle, deg_to_rad(2.0)), 0.0, 0.0))
	)


func primary(index: int):
	var target_hand = hand_handles[index]
	var og_pos = og_hand_pos[index]
	var tween = get_tree().create_tween().set_ease(Tween.EASE_OUT)
	tween.tween_property(target_hand, ^"position:z", og_pos.z - 0.1, 0.05).set_trans(
		Tween.TRANS_EXPO
	)
	tween.tween_property(target_hand, ^"position:z", og_pos.z, 0.6).set_trans(Tween.TRANS_CUBIC)
	tweens.append(tween)


func secondary(started: bool):
	for tween in tweens:
		tween.stop()
	tweens = []
	if started:
		for i in hand_handles.size():
			var hand: Marker3D = hand_handles[i]
			var tween = get_tree().create_tween().set_ease(Tween.EASE_OUT)
			tween.tween_property(hand, ^"position:x", phase_round_handles[i].position.x, 0.4).set_trans(
				Tween.TRANS_BACK
			)
			tween.parallel().tween_property(hand, ^"position:z", phase_round_handles[i].position.z, 0.4).set_trans(
				Tween.TRANS_BACK
			)
	else:
		for i in hand_handles.size():
			var hand: Marker3D = hand_handles[i]
			var tween = get_tree().create_tween().set_ease(Tween.EASE_OUT)
			tween.tween_property(hand, ^"position:x", og_hand_pos[i].x, 0.4).set_trans(
				Tween.TRANS_BACK
			)
			tween.parallel().tween_property(hand, ^"position:z", og_hand_pos[i].z, 0.4).set_trans(
				Tween.TRANS_BACK
			)
			#tween.tween_interval(0.1)
			#tween.tween_callback($metarig/Skeleton3D/TwoBoneIK3D.set_active.bind(false))
			#tween.tween_interval(0.1)
			#tween.tween_callback($metarig/Skeleton3D/TwoBoneIK3D.set_active.bind(true))
