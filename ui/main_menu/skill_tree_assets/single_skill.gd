extends Control

@onready var label: Label = $VBoxContainerLabel/HBoxContainer/Label
@onready var texture_progress_bar: TextureProgressBar = $VBoxContainerContent/HBoxContainer/TextureProgressBar

@onready var texture_button: TextureButton = $VBoxContainerContent/HBoxContainer/Panel/TextureButton
@onready var panel: Panel = $VBoxContainerContent/HBoxContainer/Panel

signal skill_unlocked(level_id: String)
signal show_information(level_id: String, state: bool)

var level: int = 0
var id: String = ""

func set_texture(_id: String, skill: Dictionary) -> void:
	var img_dict = skill[1]["img"]
	var active = skill[1]["active"]
	var normal_texture: Texture2D = load(img_dict["normal"])
	var hover_texture: Texture2D = load(img_dict["hover"])
	var disabled_texture: Texture2D = load(img_dict["disabled"])
	
	if active:
		texture_button.texture_normal = hover_texture
	else:
		texture_button.texture_normal = normal_texture
	texture_button.texture_hover = hover_texture
	texture_button.texture_disabled = disabled_texture
	
	texture_button.connect("mouse_entered", Callable(self, "_on_control_hover").bind(_id + "_1"))
	texture_button.connect("mouse_exited", Callable(self, "_on_control_hover_exit").bind(_id + "_1"))

func get_hover_style_box() -> StyleBoxFlat:
	var outline_style = StyleBoxFlat.new()
	outline_style.border_width_top = 20
	outline_style.border_width_bottom = 20
	outline_style.border_width_left = 20
	outline_style.border_width_right = 20
	outline_style.border_color = Color(1, 1, 1)  
	return outline_style

func _on_control_hover(_id: String) -> void:
	var outline_style: StyleBoxFlat = get_hover_style_box()
	
	panel.add_theme_stylebox_override("panel",outline_style)
	show_information.emit(_id, true)

func _on_control_hover_exit(_id: String) -> void:
	panel.remove_theme_stylebox_override("panel")
	show_information.emit(_id, false)

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


func skill_activated(_id: String) -> void:
	var emit_id: String = _id + "_1"
	skill_unlocked.emit(emit_id)
