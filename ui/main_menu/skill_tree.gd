extends Control

@onready var skill_content: HBoxContainer = $ScrollContainer/SkillContent
@onready var padding: Control = $ScrollContainer/SkillContent/Padding
@onready var close_popup_button: Button = $Popup/Panel/MarginContainer/VBoxContainer/HBoxContainer/CloseButton
@onready var activate_skill_button: Button = $Popup/Panel/MarginContainer/VBoxContainer/HBoxContainer/ActivateButton
@onready var deactivate_skill_button: Button = $Popup/Panel/MarginContainer/VBoxContainer/HBoxContainer/DeactivateButton

const SINGLE_SKILL: String = "res://ui/main_menu/skill_tree_assets/single_skill.tscn"
const DOUBLE_SKILL: String = "res://ui/main_menu/skill_tree_assets/double_skill.tscn"

@onready var player_start_texture: TextureRect = $ScrollContainer/SkillContent/Panel/TextureRect
@onready var player_start_outline: Panel = $ScrollContainer/SkillContent/Panel

@onready var popup: MarginContainer = $Popup
@onready var popup_header: Label = $Popup/Panel/MarginContainer/VBoxContainer/PopupHeader
@onready var pop_up_texture_rect: TextureRect = $Popup/Panel/MarginContainer/VBoxContainer/HBoxContainer2/PopUpTextureRect
@onready var popup_description: RichTextLabel = $Popup/Panel/MarginContainer/VBoxContainer/MarginContainer/Description

@onready var tooltip: MarginContainer = $Tooltip
@onready var tooltip_header: Label = $Tooltip/Panel/MarginContainer/VBoxContainer/Header
@onready var tooltip_description: RichTextLabel = $Tooltip/Panel/MarginContainer/VBoxContainer/Description

const SKILL_ACTIVE = preload("res://assets/Sound/UI/skill_active.ogg")

var fade_time: float = 0.1
var player_level: int = 0

var json_url = "res://ui/main_menu/skill_tree_assets/data/skills.json"
var skill_layout: Dictionary = {}

func _ready() -> void:
	popup.visible = false
	tooltip.visible = false
	skill_layout = PlayerSkillsManager.get_skill_layout()
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

		skill_tree_instance.call_deferred("set_level", str(id), dictionary_item["level"], player_level, prev_level)
		skill_tree_instance.call_deferred("set_texture", str(id), dictionary_item["skill"])
		prev_level = dictionary_item["level"]
	
		skill_tree_instance.connect("skill_unlocked", Callable(self, "on_skill_unlocked"))
		skill_tree_instance.connect("show_information", Callable(self, "on_show_information"))


func on_skill_unlocked(skill_id: String) -> void:	
	show_skill_information(skill_id)
	if activate_skill_button.button_down.is_connected(on_skill_activated):
		activate_skill_button.button_down.disconnect(on_skill_activated.bind("*"))
	activate_skill_button.button_down.connect(on_skill_activated.bind(skill_id))
	
	if deactivate_skill_button.button_down.is_connected(deactivate_skill):
		deactivate_skill_button.button_down.disconnect(deactivate_skill.bind("*"))
	deactivate_skill_button.button_down.connect(deactivate_skill.bind(skill_id))

func deactivate_all_skills_in_column(skill_id_a: String) -> void:
		var skills: Dictionary = skill_layout[skill_id_a]["skill"]
		for key: String in skills:
			skills[key]["active"] = false
			skills[key]["chosen_not_to_be_active"] = true

func reactivate_all_skills_in_column(skill_id_a: String) -> void:
		var skills: Dictionary = skill_layout[skill_id_a]["skill"]
		for key: String in skills:
			var skill = skills[key]
			if skill["active"]:
				match skill["action"]:
					"set_new_healt_scaler":
						PlayerSkillsManager.remove_from_healt_scaler(skill["action_value"])
					"set_new_bullet_damage_scaler":
						PlayerSkillsManager.remove_from_bullet_damage_scaler(skill["action_value"])
					"set_new_health_regeneration_scaler":
						PlayerSkillsManager.remove_from_health_regeneration_scaler(skill["action_value"])
					"set_new_money_increase":
						PlayerSkillsManager.remove_from_money_increase(skill["action_value"])
			skill["active"] = false
			skill["chosen_not_to_be_active"] = false
			

func on_skill_activated(skill_id: String) -> void:
	var player = AudioStreamPlayer.new()
	player.stream = SKILL_ACTIVE
	player.bus = "UI"
	
	add_child(player)
	
	player.play()
	player.connect("finished", Callable(player, "queue_free"))
	
	var id_parts = skill_id.split("_")
	var id_a = id_parts[0]
	var id_b = id_parts[1]
	
	deactivate_skill_button.disabled = false
	activate_skill_button.disabled = true
	
	var nr_of_skills_in_column: int = skill_layout[id_a]["skill"].size()
	if nr_of_skills_in_column > 1:
		deactivate_all_skills_in_column(id_a)
	
	skill_layout[id_a]["skill"][id_b]["active"] = true
	skill_layout[id_a]["skill"][id_b]["chosen_not_to_be_active"] = true
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

func deactivate_skill(skill_id: String) -> void:
	var id_parts = skill_id.split("_")
	var id_a = id_parts[0]
	var id_b = id_parts[1]
	var skill = skill_layout[id_a]["skill"][id_b]
	reactivate_all_skills_in_column(id_a)
	skill["active"] = false
	deactivate_skill_button.disabled = true
	activate_skill_button.disabled = false
	init_skill_tree()

func show_skill_information(skill_id: String) -> void:
	var parts = skill_id.split("_")  # Split the string at the underscore 
	var id_a = parts[0] 
	var id_b = parts[1] # id_b = 1 if single, if double 1 or 2
	
	var new_skill = skill_layout[id_a]["skill"][id_b]
	
	deactivate_skill_button.disabled = !new_skill["active"]
	activate_skill_button.disabled = new_skill["active"]

	
	popup_header.text = str(new_skill["name"])
	
	var description = new_skill["description"]
	popup_description.clear()
	popup_description.append_text(description)
	popup.visible = true

	var skill_texture: Texture2D = load(new_skill["img"]["hover"])
	pop_up_texture_rect.texture = skill_texture

func open_information_tab(skill_id: String) -> void:
	var parts = skill_id.split("_") 
	var id_a = parts[0]
	var id_b = parts[1]
	
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
	
func get_hover_style_box() -> StyleBoxFlat:
	var outline_style = StyleBoxFlat.new()
	outline_style.border_width_top = 20
	outline_style.border_width_bottom = 20
	outline_style.border_width_left = 20
	outline_style.border_width_right = 20
	outline_style.border_color = Color(1, 1, 1)  
	return outline_style


func on_show_player(state: bool) -> void:
	var tween = create_tween()
	if !state:
		player_start_outline.remove_theme_stylebox_override("panel")
		tween.tween_property(tooltip, "modulate:a", 0, fade_time)
		return
	
	player_start_outline.add_theme_stylebox_override("panel",get_hover_style_box())
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
	
