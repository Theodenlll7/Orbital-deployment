extends Control

@onready var mission_1_button: Button = $content/ContentMarginContainer/VBoxContainer/Title/HBoxContainer/Control/HBoxContainer/Buttons/MarginContainer/MarginContainer/ScrollContainer/VBoxContainer/Mission1Button
@onready var mission_2_button: Button = $content/ContentMarginContainer/VBoxContainer/Title/HBoxContainer/Control/HBoxContainer/Buttons/MarginContainer/MarginContainer/ScrollContainer/VBoxContainer/Mission2Button
@onready var mission_3_button: Button = $content/ContentMarginContainer/VBoxContainer/Title/HBoxContainer/Control/HBoxContainer/Buttons/MarginContainer/MarginContainer/ScrollContainer/VBoxContainer/Mission3Button

@onready var back_button: Button = $content/ContentMarginContainer/BackButton

@onready var mission_marker: Control = $mission_marker

@onready var mission_title_label: RichTextLabel = $content/ContentMarginContainer/VBoxContainer/Title/HBoxContainer/Control/HBoxContainer/mission_description/MarginContainer/MarginContainer/VBoxContainer/Title
@onready var mission_description_label: RichTextLabel = $content/ContentMarginContainer/VBoxContainer/Title/HBoxContainer/Control/HBoxContainer/mission_description/MarginContainer/MarginContainer/VBoxContainer/Description
@onready var texture_rect: TextureRect = $content/ContentMarginContainer/VBoxContainer/Title/HBoxContainer/Control/HBoxContainer/mission_description/MarginContainer/MarginContainer/VBoxContainer/MarginContainer/Thumbnail

signal back_mission_select
signal tab_level_selected(mission_ID, mission_position)

var planet_center = Vector2()
var marker_position = Vector2()

func _ready() -> void:
	handle_connecting_signals()
	mission_marker.visible = false

func on_mission_1_button_pressed() -> void:
	tab_level_selected.emit("1", marker_position)
	
func on_mission_2_button_pressed() -> void:
	tab_level_selected.emit("2", marker_position)

func on_mission_3_button_pressed() -> void:
	tab_level_selected.emit("3", marker_position)

	
func on_back_pressed() -> void:
	back_mission_select.emit()
	
func set_planet_center(new_center: Vector2) -> void:
	planet_center = new_center
	
func on_mission_button_hover(mission_number: String) -> void:
	var mission = MissionManager.get_mission_by_id(mission_number)
	
	var marker_offset = mission.marker_offset
	marker_position = planet_center + marker_offset
	
	mission_marker.visible = true;
	mission_marker.set_global_position(marker_position)
	
	mission_title_label.text = mission.title
	mission_description_label.text = mission.description
	var new_texture = load(mission.image_path) as Texture2D
	texture_rect.texture = new_texture
	
	
	var fade_time = 0.2 
	var opacity = 1.0
	
	var tween = create_tween()
	mission_marker.modulate.a = 0.0
	tween.tween_property(mission_marker, "modulate:a", opacity, fade_time)

func set_button_connection(mission_button: Button, mission_index: String) -> void:
	mission_button.connect("mouse_entered", Callable(self, "on_mission_button_hover").bind(mission_index))
	mission_button.connect("mouse_exited", Callable(self, "on_mission_button_hover_exit"))
	mission_button.connect("focus_entered", Callable(self, "on_mission_button_hover").bind(mission_index))
	mission_button.connect("focus_exited", Callable(self, "on_mission_button_hover_exit"))

func handle_connecting_signals() -> void:
	back_button.button_down.connect(on_back_pressed)
	
	set_button_connection(mission_1_button, "1")
	mission_1_button.button_down.connect(on_mission_1_button_pressed)

	set_button_connection(mission_2_button, "2")
	mission_2_button.button_down.connect(on_mission_2_button_pressed)
	
	set_button_connection(mission_3_button, "3")
	mission_3_button.button_down.connect(on_mission_3_button_pressed)
