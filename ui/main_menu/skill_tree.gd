extends Control

@onready var skill_content: HBoxContainer = $ScrollContainer/SkillContent
@onready var padding: Control = $ScrollContainer/SkillContent/Padding
@onready var close_popup_button: Button = $Popup/Panel/MarginContainer/VBoxContainer/HBoxContainer/CloseButton
@onready var activate_skill_button: Button = $Popup/Panel/MarginContainer/VBoxContainer/HBoxContainer/ActivateButton

const SINGLE_SKILL: String = "res://ui/main_menu/skill_tree_assets/single_skill.tscn"
const DOUBLE_SKILL: String = "res://ui/main_menu/skill_tree_assets/double_skill.tscn"


@onready var popup: MarginContainer = $Popup
@onready var popup_header: Label = $Popup/Panel/MarginContainer/VBoxContainer/PopupHeader
@onready var pop_up_texture_rect: TextureRect = $Popup/Panel/MarginContainer/VBoxContainer/HBoxContainer2/PopUpTextureRect
@onready var popup_description: Label = $Popup/Panel/MarginContainer/VBoxContainer/MarginContainer/Description

@onready var tooltip: MarginContainer = $Tooltip
@onready var tooltip_header: Label = $Tooltip/Panel/MarginContainer/VBoxContainer/Header
@onready var tooltip_description: Label = $Tooltip/Panel/MarginContainer/VBoxContainer/Description

var fade_time: float = 0.1
var player_level: int = 0

var skill_layout: Dictionary = {
	1: {
		"type": "single","level": 5,"skill":{
		1: {
			"name": "Health regeneration", 
			"description": "Lorem ipsum",
			"action": "set_new_health_regeneration_scaler",
			"action_value": 1.0,
			"img": {
				"normal": "res://ui/main_menu/assets/timeglass.png", 
				"hover": "res://ui/main_menu/assets/timeglassHover.png", 
				"disabled": "res://ui/main_menu/assets/timeglassDisabled.png"
				},
			"active": false
			}
		},
	},
	2: {
		"type": "double","level": 10,"skill":{
		1: {
			"name": "More bullet damage", 
			"description": "Lorem ipsum",
			"action": "set_new_bullet_damage_scaler",
			"action_value": 5.0,
			"img": {
				"normal": "res://ui/main_menu/assets/bulletdamage.png", 
				"hover": "res://ui/main_menu/assets/bulletdamageHover.png", 
				"disabled": "res://ui/main_menu/assets/bulletdamageDisabled.png"
				},
			"active": false
			},
		2: {
			"name": "More health",
			"description": "Lorem ipsum",
			"action": "set_new_healt_scaler",
			"action_value": 2,
		 	"img": {
				"normal": "res://ui/main_menu/assets/heart.png", 
				"hover": "res://ui/main_menu/assets/heartHover.png", 
				"disabled": "res://ui/main_menu/assets/heartDisabled.png"
				},
			"active": false
			}
		}
	},
	3: {
		"type": "single","level": 15,"skill":{
		1:{
			"name": "More health",
			"description": "Lorem ipsum",
			"action": "set_new_healt_scaler",
			"action_value": 10.0,
		 	"img": {
				"normal": "res://ui/main_menu/assets/heart.png", 
				"hover": "res://ui/main_menu/assets/heartHover.png", 
				"disabled": "res://ui/main_menu/assets/heartDisabled.png"
				},
			"active": false
			}
		},
	},
}

func _ready() -> void:
	popup.visible = false
	tooltip.visible = false
	ExperiencePoints.connect("experience_updated", Callable(self, "on_experience_updated"))
	init_skill_tree()
	handle_connecting_signals()

func on_experience_updated() -> void:
	init_skill_tree()
	
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

		skill_tree_instance.call_deferred("set_texture", str(id), dictionary_item["skill"])
		skill_tree_instance.call_deferred("set_level", str(id), dictionary_item["level"], player_level, prev_level)
		prev_level = dictionary_item["level"]
	
		skill_tree_instance.connect("skill_unlocked", Callable(self, "on_skill_unlocked"))
		skill_tree_instance.connect("show_information", Callable(self, "on_show_information"))


func on_skill_unlocked(skill_id: String) -> void:
	print("Skill unlocked with id " + skill_id + "!")
	
	show_skill_information(skill_id)
	activate_skill_button.button_down.disconnect(on_skill_activated.bind("*"))
	activate_skill_button.button_down.connect(on_skill_activated.bind(skill_id))

func on_skill_activated(skill_id: String) -> void:
	var id_parts = skill_id.split("_")
	var id_a = int(id_parts[0]) 
	var id_b = int(id_parts[1])
	
	print("Skill active with id " + skill_id + "!")
	skill_layout[id_a]["skill"][id_b]["active"] = true
	init_skill_tree()
	
	var skill = skill_layout[id_a]["skill"][id_b]
	
	match skill["action"]:
		"set_new_healt_scaler":
			PlayerSkillsManager.set_new_healt_scaler(skill["action_value"])
		"set_new_bullet_damage_scaler":
			PlayerSkillsManager.set_new_bullet_damage_scaler(skill["action_value"])
		"set_new_health_regeneration_scaler":
			PlayerSkillsManager.set_new_health_regeneration_scaler(skill["action_value"])

func show_skill_information(skill_id: String) -> void:
	var parts = skill_id.split("_")  # Split the string at the underscore 
	var id_a = int(parts[0]) 
	var id_b = int(parts[1]) # id_b = 1 if single, if double 1 or 2
	
	var new_skill = skill_layout[id_a]["skill"][id_b]
	popup_header.text = str(new_skill["name"])
	popup_description.text = str(new_skill["description"])
	popup.visible = true

	var skill_texture: Texture2D = load(new_skill["img"]["hover"])
	pop_up_texture_rect.texture = skill_texture

func open_information_tab(skill_id: String) -> void:
	var parts = skill_id.split("_") 
	var id_a = int(parts[0]) 
	var id_b = int(parts[1])
	
	var skill = skill_layout[id_a]["skill"][id_b]
	tooltip_header.text = str(skill["name"])
	tooltip_description.text = str(skill["description"])
	tooltip.visible = true

func on_show_information(skill_id: String, state: bool) -> void:
	var tween = create_tween()
	if !state:
		tween.tween_property(tooltip, "modulate:a", 0, fade_time)
		return
	open_information_tab(skill_id)
	tween.tween_property(tooltip, "modulate:a", 1, fade_time)
	
	

func handle_connecting_signals() -> void:
	close_popup_button.button_down.connect(on_close_popup_button_pressed)
