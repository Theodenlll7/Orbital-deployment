extends Control

@onready var skill_content: HBoxContainer = $ScrollContainer/SkillContent
@onready var padding: Control = $ScrollContainer/SkillContent/Padding

const SINGLE_SKILL: String = "res://ui/main_menu/skill_tree_assets/single_skill.tscn"
const DOUBLE_SKILL: String = "res://ui/main_menu/skill_tree_assets/double_skill.tscn"

const skill_layout: Dictionary = {
	1: {"type": "single","level": 5, "img": {"normal": "res://ui/main_menu/assets/heart.png", "hover": "res://ui/main_menu/assets/heartHover.png", "disabled": "res://ui/main_menu/assets/heartDisabled.png"} },
	2: {"type": "single","level": 10, "img": {"normal": "res://ui/main_menu/assets/heart.png", "hover": "res://ui/main_menu/assets/heartHover.png", "disabled": "res://ui/main_menu/assets/heartDisabled.png"} },
	3: {"type": "double","level": 15, "img": {"normal": "res://ui/main_menu/assets/heart.png", "hover": "res://ui/main_menu/assets/heartHover.png", "disabled": "res://ui/main_menu/assets/heartDisabled.png"} },
	4: {"type": "single","level": 20, "img": {"normal": "res://ui/main_menu/assets/heart.png", "hover": "res://ui/main_menu/assets/heartHover.png", "disabled": "res://ui/main_menu/assets/heartDisabled.png"} },
}

func _ready() -> void:
	init_skill_tree()

func init_skill_tree() -> void:
	var skill_tree_type: String = ""
	for id in skill_layout.keys():
		var dictionary_item = skill_layout[id]
		match dictionary_item["type"]:
			"single":
				skill_tree_type = SINGLE_SKILL
			"double":
				skill_tree_type = DOUBLE_SKILL
		var skill_tree_instance = load(skill_tree_type).instantiate()
		skill_content.add_child(skill_tree_instance)
		
		skill_tree_instance.call_deferred("set_texture", dictionary_item["img"])
		skill_tree_instance.call_deferred("set_level", dictionary_item["level"])
