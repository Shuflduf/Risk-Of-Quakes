extends Control


func add_skill(skill_info: SkillInfo, slot: Skill.SkillSlot):
	prints(skill_info.skill_name, slot)

func skill_used(slot: Skill.SkillSlot):
	print(slot)

func disable_skill(slot: Skill.SkillSlot):
	print(slot)

func enable_skill(slot: Skill.SkillSlot):
	print(slot)
