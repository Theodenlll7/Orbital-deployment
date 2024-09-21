extends Control

@onready var mission_1_button: Button = $content/ContentMarginContainer/VBoxContainer/Buttons/MarginContainer/HBoxContainer/Control/VBoxContainer/Mission1Button
@onready var mission_2_button: Button = $content/ContentMarginContainer/VBoxContainer/Buttons/MarginContainer/HBoxContainer/Control/VBoxContainer/Mission2Button
@onready var back_button: Button = $content/ContentMarginContainer/BackButton

@onready var mission_marker: Control = $mission_marker
@onready var mission_label: Label = $content/ContentMarginContainer/VBoxContainer/HBoxContainer/mission_description/MarginContainer/MarginContainer/mission_label

signal back_mission_select
signal tab_level_selected(mission_ID, mission_position)

const marker_offsets: Array = [Vector2(-20, -200), Vector2(100, 10)]
const mission_descriptions: Array = [String("Mission1"), String("Mission2")]
var planet_center = Vector2()
var marker_position = Vector2()

func _ready() -> void:
	handle_connecting_signals()
	mission_marker.visible = false
	
func on_mission_1_button_pressed() -> void:
	emit_signal("tab_level_selected", "1", marker_position )
	
func on_back_pressed() -> void:
	back_mission_select.emit()
	
func set_planet_center(new_center: Vector2) -> void:
	planet_center = new_center
	
func on_mission_button_hover(mission_nmber: int) -> void:	
	var marker_offset = marker_offsets[mission_nmber - 1]
	marker_position = planet_center + marker_offset
	
	mission_marker.visible = true;	
	mission_marker.set_global_position(marker_position)
	mission_label.text = mission_descriptions[mission_nmber - 1]
	
	var fade_time = 0.2 
	var opacity = 1.0
	
	var tween = create_tween()
	mission_marker.modulate.a = 0.0
	tween.tween_property(mission_marker, "modulate:a", opacity, fade_time)

func set_button_connection(mission_button: Button, mission_index: int) -> void:
	mission_button.connect("mouse_entered", Callable(self, "on_mission_button_hover").bind(mission_index))
	mission_button.connect("mouse_exited", Callable(self, "on_mission_button_hover_exit"))
	mission_button.connect("focus_entered", Callable(self, "on_mission_button_hover").bind(mission_index))
	mission_button.connect("focus_exited", Callable(self, "on_mission_button_hover_exit"))

func handle_connecting_signals() -> void:
	back_button.button_down.connect(on_back_pressed)
	
	set_button_connection(mission_1_button, 1)
	mission_1_button.button_down.connect(on_mission_1_button_pressed)

	set_button_connection(mission_2_button, 2)
