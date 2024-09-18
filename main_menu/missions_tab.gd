extends Control

@onready var mission_1_button: Button = $content/ContentMarginContainer/VBoxContainer/Buttons/MarginContainer/HBoxContainer/Control/VBoxContainer/Mission1Button
@onready var mission_2_button: Button = $content/ContentMarginContainer/VBoxContainer/Buttons/MarginContainer/HBoxContainer/Control/VBoxContainer/Mission2Button
@onready var back_button: Button = $content/ContentMarginContainer/BackButton

@onready var mission_marker: Control = $mission_marker
@onready var planet_texture_rect: TextureRect = $Planet/TextureRect
@onready var mission_label: Label = $content/ContentMarginContainer/VBoxContainer/HBoxContainer/mission_description/MarginContainer/MarginContainer/mission_label

signal back_mission_select

const marker_offsets: Array = [Vector2(-20, -200), Vector2(100, 10)]
const mission_descriptions: Array = [String("Mission1"), String("Mission2")]

func _ready() -> void:
	handle_connecting_signals()
	mission_marker.visible = false
	
func on_back_pressed() -> void:
	back_mission_select.emit()
	
func on_mission_button_hover(mission_nmber: int) -> void:	
	var marker_area_center = planet_texture_rect.global_position + planet_texture_rect.size / 2
	var marker_offset = marker_offsets[mission_nmber - 1]
	var marker_position = marker_area_center + marker_offset
	
	mission_marker.visible = true;	
	mission_marker.set_global_position(marker_position)
	mission_label.text = mission_descriptions[mission_nmber - 1]
	
	var fade_time = 0.2 
	var opacity = 1.0
	
	var tween = create_tween()
	mission_marker.modulate.a = 0.0
	tween.tween_property(mission_marker, "modulate:a", opacity, fade_time)

func handle_connecting_signals() -> void:
	back_button.button_down.connect(on_back_pressed)
	
	mission_1_button.connect("mouse_entered", Callable(self, "on_mission_button_hover").bind(1))
	mission_1_button.connect("mouse_exited", Callable(self, "on_mission_button_hover_exit"))

	mission_2_button.connect("mouse_entered", Callable(self, "on_mission_button_hover").bind(2))
	mission_2_button.connect("mouse_exited", Callable(self, "on_mission_button_hover_exit"))
