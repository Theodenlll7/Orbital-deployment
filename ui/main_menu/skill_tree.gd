extends Control

@onready var skill_content: HBoxContainer = $ScrollContainer/SkillContent
@onready var padding: Control = $ScrollContainer/SkillContent/Padding
@onready var close_popup_button: Button = $Popup/Panel/MarginContainer/VBoxContainer/HBoxContainer/CloseButton
@onready var activate_skill_button: Button = $Popup/Panel/MarginContainer/VBoxContainer/HBoxContainer/ActivateButton

const SINGLE_SKILL: String = "res://ui/main_menu/skill_tree_assets/single_skill.tscn"
const DOUBLE_SKILL: String = "res://ui/main_menu/skill_tree_assets/double_skill.tscn"

@onready var player_start_texture: TextureRect = $ScrollContainer/SkillContent/TextureRect

@onready var popup: MarginContainer = $Popup
@onready var popup_header: Label = $Popup/Panel/MarginContainer/VBoxContainer/PopupHeader
@onready var pop_up_texture_rect: TextureRect = $Popup/Panel/MarginContainer/VBoxContainer/HBoxContainer2/PopUpTextureRect
@onready var popup_description: RichTextLabel = $Popup/Panel/MarginContainer/VBoxContainer/MarginContainer/Description

@onready var tooltip: MarginContainer = $Tooltip
@onready var tooltip_header: Label = $Tooltip/Panel/MarginContainer/VBoxContainer/Header
@onready var tooltip_description: RichTextLabel = $Tooltip/Panel/MarginContainer/VBoxContainer/Description

var fade_time: float = 0.1
var player_level: int = 0

var skill_layout: Dictionary = {
	1: {
		"type": "single","level": 5,"skill":{
		1: {
			"name": "Health regeneration", 
			"description": "Your soldier's veins will be buzzing with Earth's top-tier health nanobots. \n\nThese little guys work around the clock, patching up wounds and restoring [color=green]1 health point every second[/color] just like having a personal medic on speed dial!",
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
			"description": "Your soldier's bullets will be crafted from the legendary Lerus scales, harvested from the colony of Epros. \n\nThese ultra-dense scales add brutal stopping power, [color=green]boosting bullet damage by 1.5x[/color]. Each shot now hits harder than ever before—straight from Epros, straight to your enemies!",
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
			"description": "Thanks to the brilliant scientists of Nexus, you're about to double your durability! \n\nTheir cutting-edge bioengineering will [color=green]increase your max health by 2x[/color], making you tougher, stronger, and unstoppable. Nexus tech is about to supercharge you!",
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
			"name": "More start credits",
			"description": "Thanks to the Banking Federation’s unwavering support of liberation, you're [color=green]starting with 500 bonus credits[/color]! \n\nThey've got your back, fueling your fight with some extra cash to gear up and get ahead right from the start. Freedom’s never been so well-funded!",
			"action": "set_new_money_increase",
			"action_value": 500,
		 	"img": {
				"normal": "res://ui/main_menu/assets/moremoney.png", 
				"hover": "res://ui/main_menu/assets/moremoneyHover.png", 
				"disabled": "res://ui/main_menu/assets/moremoneyDisabled.png"
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
		"set_new_money_increase":
			PlayerSkillsManager.set_new_money_increase(skill["action_value"])

func show_skill_information(skill_id: String) -> void:
	var parts = skill_id.split("_")  # Split the string at the underscore 
	var id_a = int(parts[0]) 
	var id_b = int(parts[1]) # id_b = 1 if single, if double 1 or 2
	
	var new_skill = skill_layout[id_a]["skill"][id_b]
	popup_header.text = str(new_skill["name"])
	
	var description = new_skill["description"]
	popup_description.clear()
	popup_description.append_text(description)
	popup.visible = true

	var skill_texture: Texture2D = load(new_skill["img"]["hover"])
	pop_up_texture_rect.texture = skill_texture

func open_information_tab(skill_id: String) -> void:
	var parts = skill_id.split("_") 
	var id_a = int(parts[0]) 
	var id_b = int(parts[1])
	
	var skill = skill_layout[id_a]["skill"][id_b]
	tooltip_header.text = str(skill["name"])
	var description = skill["description"]
	tooltip_description.clear()
	tooltip_description.append_text(description)
	tooltip.visible = true

func on_show_information(skill_id: String, state: bool) -> void:
	var tween = create_tween()
	if !state:
		tween.tween_property(tooltip, "modulate:a", 0, fade_time)
		return
	open_information_tab(skill_id)
	tween.tween_property(tooltip, "modulate:a", 1, fade_time)
	
func on_show_player(state: bool) -> void:
	var tween = create_tween()
	if !state:
		tween.tween_property(tooltip, "modulate:a", 0, fade_time)
		return
	
	tooltip_header.text = "You"
	var description = "This is [color=green]you[/color] a breathtaking force of nature, poised to liberate the galaxy from heretics. Admire your sleek design—a true killing machine ready to unleash chaos on your foes. \n\nGet ready to make your mark!"
	tooltip_description.clear()
	tooltip_description.append_text(description)
	tooltip.visible = true
	
	tween.tween_property(tooltip, "modulate:a", 1, fade_time)
	
	
func handle_connecting_signals() -> void:
	close_popup_button.button_down.connect(on_close_popup_button_pressed)
	player_start_texture.connect("mouse_entered", on_show_player.bind(true))
	player_start_texture.connect("mouse_exited", on_show_player.bind(false))
