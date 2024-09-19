class_name MissionSelect
extends Control

@onready var missions_button: Button = $Content/ContentMarginContainer/VBoxContainer/Buttons/MarginContainer/HBoxContainer/Control/VBoxContainer/MissionsButton
@onready var infinite_survival_button: Button = $Content/ContentMarginContainer/VBoxContainer/Buttons/MarginContainer/HBoxContainer/Control/VBoxContainer/InfiniteSurvivalButton
@onready var back_button: Button = $Content/ContentMarginContainer/BackButton

@onready var planet_texture_rect: TextureRect = $Planet/TextureRect
@onready var infinite_survival_texture_rect: Control = $infinit_marker
@onready var mission_label: Label = $Content/ContentMarginContainer/VBoxContainer/HBoxContainer/mission_description/MarginContainer/MarginContainer/mission_label

@onready var content: Control = $Content
@onready var missions_tab: Control = $missions_tab


signal level_selected(level_ID)
signal back_to_main_menu

var planet_center = Vector2()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	handle_connecting_signals()

	planet_center = planet_texture_rect.global_position + planet_texture_rect.size / 2
	missions_tab.set_planet_center(planet_center)
	visible = false
	set_process(true)
	
	missions_tab.visible = false;
	
	infinite_survival_texture_rect.visible = false

func on_missions_button_pressed() -> void:
	content.visible = false
	missions_tab.visible = true

func on_exit_mission_tab() -> void:
	content.visible = true
	missions_tab.visible = false

func on_infinite_button_pressed() -> void:
	emit_signal("level_selected", "infinite")

func on_mission_selected_from_tab(mission_ID: String) -> void:
	emit_signal("level_selected", mission_ID)

func on_infinite_survival_button_hover() -> void:
	var marker_offset = Vector2(-300, -200)
	var marker_position = planet_center + marker_offset
	
	infinite_survival_texture_rect.visible = true;
	infinite_survival_texture_rect.set_global_position(marker_position)
	
	var fade_time = 0.2 
	var opacity = 1.0
	
	infinite_survival_texture_rect.modulate.a = 0.0
	mission_label.modulate.a = 0.0

	mission_label.text = "You will not survive..."
	
	var tween = create_tween()
	tween.tween_property(mission_label, "modulate:a", opacity, fade_time)
	tween.parallel().tween_property(infinite_survival_texture_rect, "modulate:a", opacity, fade_time)

	
func on_infinite_survival_button_hover_exit() -> void:
	infinite_survival_texture_rect.visible = false
	mission_label.text = ""

func on_back_pressed() -> void:
	back_to_main_menu.emit()
	
func handle_connecting_signals() -> void:
	missions_button.button_down.connect(on_missions_button_pressed)
	
	infinite_survival_button.button_down.connect(on_infinite_button_pressed)
	back_button.button_down.connect(on_back_pressed)
	
	missions_tab.back_mission_select.connect(on_exit_mission_tab)
	
	missions_tab.connect("tab_level_selected", Callable(self, "on_mission_selected_from_tab"))

	
	infinite_survival_button.connect("mouse_entered", Callable(self, "on_infinite_survival_button_hover"))
	infinite_survival_button.connect("mouse_exited", Callable(self, "on_infinite_survival_button_hover_exit"))
