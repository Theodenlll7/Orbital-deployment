extends Control

@onready var label: Label = $VBoxContainerLabel/HBoxContainer/Label

@onready var texture_progress_bar: TextureProgressBar = $VBoxContainerContent/HBoxContainer/TextureProgressBar
@onready var texture_button_top: TextureButton = $VBoxContainerContent/HBoxContainer/VBoxContainer/TextureButtonTop
@onready var texture_button_bottom: TextureButton = $VBoxContainerContent/HBoxContainer/VBoxContainer/TextureButtonBottom

signal skill_unlocked

var level: int = 0

func set_texture(_id: int, img_dict: Dictionary) -> void:
	var normal_texture: Texture2D = load(img_dict["normal"])
	var hover_texture: Texture2D = load(img_dict["hover"])
	var disabled_texture: Texture2D = load(img_dict["disabled"])
	
	texture_button_top.texture_normal = normal_texture
	texture_button_top.texture_hover = hover_texture
	texture_button_top.texture_disabled = disabled_texture
	
	texture_button_bottom.texture_normal = normal_texture
	texture_button_bottom.texture_hover = hover_texture
	texture_button_bottom.texture_disabled = disabled_texture

func set_level(_id: int, this_level: int, player_level: int, prev_level: int) -> void:
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
	texture_button_top.button_down.connect(skill_activated)
	texture_button_bottom.button_down.connect(skill_activated)


func skill_activated() -> void:
	skill_unlocked.emit()
