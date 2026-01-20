extends Node3D

const SPINE_INDEX = 0
@export var hand_anims: Dictionary[AnimationPlayer, StringName]
@export var cleaver_parents: Dictionary[AnimationPlayer, Node3D]
@export var skeleton: Skeleton3D

var next_hand_index = 0

@onready var particles: GPUParticles3D = $Armature/Skeleton3D/Bone/Particles
@onready var boost_particles: GPUParticles3D = $Armature/Skeleton3D/Bone/BoostParticles

#@onready var right_hand: Marker3D = $metarig/Skeleton3D/spine_004/RightHand
#@onready var right_hand_og_trans = right_hand.transform


func set_spine_angle(new_angle: float):
	skeleton.set_bone_pose_rotation(
		SPINE_INDEX, Quaternion.from_euler(Vector3(snappedf(new_angle, deg_to_rad(2.0)), 0.0, 0.0))
	)


func connect_skills(skills: Dictionary[Skill.SkillSlot, Skill]):
	skills[Skill.SkillSlot.PRIMARY].used.connect(primary)
	skills[Skill.SkillSlot.SECONDARY].used.connect(secondary)


func primary(caught: bool, boosted: bool, can_shoot_more: bool):
	if not caught and not boosted:
		var target_player: AnimationPlayer = hand_anims.keys()[next_hand_index]
		target_player.play(hand_anims[target_player])
		cleaver_parents[target_player].visible = can_shoot_more
		next_hand_index += 1
		next_hand_index %= hand_anims.size()
	elif caught:
		var target_player: AnimationPlayer = hand_anims.keys()[next_hand_index]
		cleaver_parents[target_player].visible = can_shoot_more
		next_hand_index += 1
		next_hand_index %= hand_anims.size()


func secondary(activated: bool, boosted: bool):
	var target_particles = boost_particles if boosted else particles
	target_particles.emitting = activated
