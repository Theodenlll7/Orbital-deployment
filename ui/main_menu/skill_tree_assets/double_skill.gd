extends Control

@onready var label: Label = $VBoxContainerLabel/HBoxContainer/Label

@onready var texture_progress_bar: TextureProgressBar = $VBoxContainerContent/HBoxContainer/TextureProgressBar
@onready var texture_button_top: TextureButton = $VBoxContainerContent/HBoxContainer/VBoxContainer/TextureButtonTop
@onready var texture_button_bottom: TextureButton = $VBoxContainerContent/HBoxContainer/VBoxContainer/TextureButtonBottom
@onready var end_texture_progress_bar: TextureProgressBar = $VBoxContainerContent/HBoxContainer/VBoxContainer/EndTextureProgressBar

signal skill_unlocked(level_id: String)

var level: int = 0

func set_texture(_id: String, skill: Dictionary) -> void:
	var img_dict_top = skill[1]["img"]
	var img_dict_bottom = skill[2]["img"]

	var normal_texture_top: Texture2D = load(img_dict_top["normal"])
	var hover_texture_top: Texture2D = load(img_dict_top["hover"])
	var disabled_texture_top: Texture2D = load(img_dict_top["disabled"])
	
	var normal_texture_bottom: Texture2D = load(img_dict_bottom["normal"])
	var hover_texture_bottom: Texture2D = load(img_dict_bottom["hover"])
	var disabled_texture_bottom: Texture2D = load(img_dict_bottom["disabled"])
	
	texture_button_top.texture_normal = normal_texture_top
	texture_button_top.texture_hover = hover_texture_top
	texture_button_top.texture_disabled = disabled_texture_top

	texture_button_bottom.texture_normal = normal_texture_bottom
	texture_button_bottom.texture_hover = hover_texture_bottom
	texture_button_bottom.texture_disabled = disabled_texture_bottom
	
func set_level(_id: String, this_level: int, player_level: int, prev_level: int) -> void:
	level = this_level
	label.text = "Level " + str(level)

	var experience_needed = ExperiencePoints.get_experience_needed_from_start_to_this(level)
	var experience = ExperiencePoints.get_total_amount_of_experience_points()

	if(level > player_level):
		texture_button_top.disabled = true
		texture_button_bottom.disabled = true
		if(prev_level <= player_level):
			texture_progress_bar.max_value = experience_needed
			texture_progress_bar.value = experience
		else:
			texture_progress_bar.max_value = 1
			texture_progress_bar.value = 0
	else:
		texture_progress_bar.max_value = 1
		texture_progress_bar.value = 1
		end_texture_progress_bar.max_value = 1
		end_texture_progress_bar.value = 1

	texture_button_top.button_down.connect(Callable(self, "skill_activated").bind(_id + "_2"))
	texture_button_bottom.button_down.connect(Callable(self, "skill_activated").bind(_id + "_1"))



func skill_activated(_id: String) -> void:
	skill_unlocked.emit(_id)
