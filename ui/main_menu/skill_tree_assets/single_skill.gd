extends Control

@onready var label: Label = $VBoxContainerLabel/HBoxContainer/Label
@onready var texture_progress_bar: TextureProgressBar = $VBoxContainerContent/HBoxContainer/TextureProgressBar

@onready var texture_button: TextureButton = $VBoxContainerContent/HBoxContainer/TextureButton

signal skill_unlocked(level_id: String)

var level: int = 0


func set_texture(_id: String, skill: Dictionary) -> void:
	var img_dict = skill[1]["img"]
	var normal_texture: Texture2D = load(img_dict["normal"])
	var hover_texture: Texture2D = load(img_dict["hover"])
	var disabled_texture: Texture2D = load(img_dict["disabled"])
	
	texture_button.texture_normal = normal_texture
	texture_button.texture_hover = hover_texture
	texture_button.texture_disabled = disabled_texture

func set_level(_id: String, this_level: int, player_level: int, prev_level: int) -> void:
	level = this_level
	label.text = "Level " + str(level)

	var experience_needed = ExperiencePoints.get_experience_needed_from_start_to_this(level)
	var experience = ExperiencePoints.get_total_amount_of_experience_points()

	if(level > player_level):
		texture_button.disabled = true
		if(prev_level <= player_level):
			texture_progress_bar.max_value = experience_needed
			texture_progress_bar.value = experience
		else:
			texture_progress_bar.max_value = 1
			texture_progress_bar.value = 0
	else:
		texture_progress_bar.max_value = 1
		texture_progress_bar.value = 1
	texture_button.button_down.connect(Callable(self, "skill_activated").bind(_id))


func skill_activated(id: String) -> void:
	var emit_id: String = id + "_1"
	skill_unlocked.emit(emit_id)
