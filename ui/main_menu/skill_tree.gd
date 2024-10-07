extends Control

@onready var skill_content: HBoxContainer = $ScrollContainer/SkillContent
@onready var padding: Control = $ScrollContainer/SkillContent/Padding
@onready var close_popup_button: Button = $Popup/Panel/MarginContainer/VBoxContainer/HBoxContainer/CloseButton
@onready var dev_button: Button = $Dev

const SINGLE_SKILL: String = "res://ui/main_menu/skill_tree_assets/single_skill.tscn"
const DOUBLE_SKILL: String = "res://ui/main_menu/skill_tree_assets/double_skill.tscn"
@onready var popup: MarginContainer = $Popup

var player_level: int = 0

const skill_layout: Dictionary = {
	1: {"type": "single","level": 5, "img": {"normal": "res://ui/main_menu/assets/heart.png", "hover": "res://ui/main_menu/assets/heartHover.png", "disabled": "res://ui/main_menu/assets/heartDisabled.png"} },
	2: {"type": "single","level": 10, "img": {"normal": "res://ui/main_menu/assets/heart.png", "hover": "res://ui/main_menu/assets/heartHover.png", "disabled": "res://ui/main_menu/assets/heartDisabled.png"} },
	3: {"type": "double","level": 15, "img": {"normal": "res://ui/main_menu/assets/heart.png", "hover": "res://ui/main_menu/assets/heartHover.png", "disabled": "res://ui/main_menu/assets/heartDisabled.png"} },
	4: {"type": "single","level": 20, "img": {"normal": "res://ui/main_menu/assets/heart.png", "hover": "res://ui/main_menu/assets/heartHover.png", "disabled": "res://ui/main_menu/assets/heartDisabled.png"} },
}

func _ready() -> void:
	popup.visible = false
	ExperiencePoints.connect("experience_updated", Callable(self, "on_experience_updated"))
	init_skill_tree()
	handle_connecting_signals()

func on_experience_updated() -> void:
	init_skill_tree()

#func on_activate_skill_pressed() -> void:
	
func on_close_popup_button_pressed() -> void:
	popup.visible = false


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

		skill_tree_instance.call_deferred("set_texture", id, dictionary_item["img"])
		skill_tree_instance.call_deferred("set_level", id, dictionary_item["level"], player_level, prev_level)
		prev_level = dictionary_item["level"]
		
		skill_tree_instance.connect("skill_unlocked", Callable(self, "on_skill_unlocked"))

func on_skill_unlocked() -> void:
	print("Skill unlocked!")
	show_skill_information()

func show_skill_information() -> void:
		popup.visible = true

func handle_connecting_signals() -> void:
	close_popup_button.button_down.connect(on_close_popup_button_pressed)
	dev_button.button_down.connect(show_skill_information)
	
