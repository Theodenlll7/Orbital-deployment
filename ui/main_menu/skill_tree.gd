extends Control

@onready var skill_content: HBoxContainer = $ScrollContainer/SkillContent
@onready var padding: Control = $ScrollContainer/SkillContent/Padding

const SINGLE_SKILL: String = "res://ui/main_menu/skill_tree_assets/single_skill.tscn"
const DOUBLE_SKILL: String = "res://ui/main_menu/skill_tree_assets/double_skill.tscn"

var player_level: int = 0

const skill_layout: Dictionary = {
	1: {"type": "single","level": 5, "img": {"normal": "res://ui/main_menu/assets/heart.png", "hover": "res://ui/main_menu/assets/heartHover.png", "disabled": "res://ui/main_menu/assets/heartDisabled.png"} },
	2: {"type": "single","level": 10, "img": {"normal": "res://ui/main_menu/assets/heart.png", "hover": "res://ui/main_menu/assets/heartHover.png", "disabled": "res://ui/main_menu/assets/heartDisabled.png"} },
	3: {"type": "double","level": 15, "img": {"normal": "res://ui/main_menu/assets/heart.png", "hover": "res://ui/main_menu/assets/heartHover.png", "disabled": "res://ui/main_menu/assets/heartDisabled.png"} },
	4: {"type": "single","level": 20, "img": {"normal": "res://ui/main_menu/assets/heart.png", "hover": "res://ui/main_menu/assets/heartHover.png", "disabled": "res://ui/main_menu/assets/heartDisabled.png"} },
}

func _ready() -> void:
	ExperiencePoints.connect("experience_updated", Callable(self, "on_experience_updated"))
	init_skill_tree()

func on_experience_updated() -> void:
	init_skill_tree()

func init_skill_tree() -> void:
	player_level = ExperiencePoints.get_current_level()

	var children = skill_content.get_children()
	for i in range(children.size() - 1, 1, -1):
		children[i].queue_free() 
	
	var skill_tree_type: String = ""
	var prev_level: int = 1
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
		skill_tree_instance.call_deferred("set_level", dictionary_item["level"], player_level, prev_level)
		prev_level = dictionary_item["level"]
