extends Control

@onready var label: Label = $VBoxContainerLabel/HBoxContainer/Label

@onready var texture_progress_bar: TextureProgressBar = $VBoxContainerContent/HBoxContainer/TextureProgressBar
@onready var end_texture_progress_bar: TextureProgressBar = $VBoxContainerContent/HBoxContainer/VBoxContainer/EndTextureProgressBar

@onready var texture_button_top: TextureButton = $VBoxContainerContent/HBoxContainer/VBoxContainer/PanelTop/TextureButtonTop
@onready var panel_top: Panel = $VBoxContainerContent/HBoxContainer/VBoxContainer/PanelTop
@onready var texture_button_bottom: TextureButton = $VBoxContainerContent/HBoxContainer/VBoxContainer/PanelBottom/TextureButtonBottom
@onready var panel_bottom: Panel = $VBoxContainerContent/HBoxContainer/VBoxContainer/PanelBottom

signal skill_unlocked(level_id: String)
signal show_information(level_id: String, state: bool)

var level: int = 0

func set_texture(_id: String, skill: Dictionary) -> void:
	var img_dict_top = skill["1"]["img"]
	var img_dict_bottom = skill["2"]["img"]
	var active_top = skill["1"]["active"]
	var active_bottom = skill["2"]["active"]
	var chosen_not_to_be_active_top = skill["1"]["chosen_not_to_be_active"]
	var chosen_not_to_be_active_bottom = skill["2"]["chosen_not_to_be_active"]

	var hover_texture_top: Texture2D = load(img_dict_top["hover"])
	var normal_texture_top: Texture2D = load(img_dict_top["normal"])
	var disabled_texture_top: Texture2D = load(img_dict_top["disabled"])
	
	var normal_texture_bottom: Texture2D = load(img_dict_bottom["normal"])
	var hover_texture_bottom: Texture2D = load(img_dict_bottom["hover"])
	var disabled_texture_bottom: Texture2D = load(img_dict_bottom["disabled"])
	
	if active_top:
		texture_button_top.texture_normal = hover_texture_top
	else:
		texture_button_top.texture_normal = normal_texture_top
	texture_button_top.texture_hover = hover_texture_top
	texture_button_top.texture_disabled = disabled_texture_top

	if active_bottom:
		texture_button_bottom.texture_normal = hover_texture_bottom
	else:
		texture_button_bottom.texture_normal = normal_texture_bottom
	texture_button_bottom.texture_hover = hover_texture_bottom
	texture_button_bottom.texture_disabled = disabled_texture_bottom
	
	if chosen_not_to_be_active_top && !active_top:
		texture_button_top.disabled = true
	if chosen_not_to_be_active_bottom && !active_bottom:
		texture_button_bottom.disabled = true
	
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

	texture_button_top.button_down.connect(Callable(self, "skill_activated").bind(_id + "_1"))
	texture_button_top.connect("mouse_entered", Callable(self, "_on_control_hover").bind(_id + "_1"))
	texture_button_top.connect("mouse_exited", Callable(self, "_on_control_hover_exit").bind(_id + "_1"))
	
	texture_button_bottom.button_down.connect(Callable(self, "skill_activated").bind(_id + "_2"))
	texture_button_bottom.connect("mouse_entered", Callable(self, "_on_control_hover").bind(_id + "_2"))
	texture_button_bottom.connect("mouse_exited", Callable(self, "_on_control_hover_exit").bind(_id + "_2"))

func get_hover_style_box() -> StyleBoxFlat:
	var outline_style = StyleBoxFlat.new()
	outline_style.border_width_top = 20
	outline_style.border_width_bottom = 20
	outline_style.border_width_left = 20
	outline_style.border_width_right = 20
	outline_style.border_color = Color(1, 1, 1)  
	return outline_style


func getIdB(id: String) -> String:
	return id.split("_")[1]

func _on_control_hover(_id: String) -> void:
	var outline_style: StyleBoxFlat = get_hover_style_box()
	
	if getIdB(_id) == "1":
		panel_top.add_theme_stylebox_override("panel",outline_style)
		show_information.emit(_id, true)
	else:
		panel_bottom.add_theme_stylebox_override("panel",outline_style)
		show_information.emit(_id, true)

func _on_control_hover_exit(_id: String) -> void:
	if getIdB(_id) == "1":
		panel_top.remove_theme_stylebox_override("panel")
		show_information.emit(_id, false)
	else:
		panel_bottom.remove_theme_stylebox_override("panel")
		show_information.emit(_id, false)

func skill_activated(_id: String) -> void:
	skill_unlocked.emit(_id)
