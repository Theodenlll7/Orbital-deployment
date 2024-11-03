class_name MissionSelect
extends Control

@onready var missions_button: Button = $HSplitContainer/ModeTabe/VBoxContainer/MissionsButton
@onready var infinite_survival_button: Button = $HSplitContainer/ModeTabe/VBoxContainer/InfiniteSurvivalButton
@onready var back_button: Button = $HSplitContainer/ModeTabe/BackButton
@onready var mode_tab := $HSplitContainer/ModeTabe

@onready var planet_texture_rect := $HSplitContainer/Planet
@onready var infinite_survival_texture_rect: Control = $HSplitContainer/Planet/infinit_marker
@onready var mission_label: Label = $HSplitContainer/ModeTabe/VBoxContainer/Label

@onready var missions_tab := $HSplitContainer/missions_tab

signal back_to_main_menu
signal level_selected(mission_ID, mission_position)

var infinite_hover_text = "Coming soon!" # "You will not survive..."
var planet_center = Vector2()
var marker_position = Vector2()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	handle_connecting_signals()

	planet_center = planet_texture_rect.global_position + planet_texture_rect.size / 2
	missions_tab.set_planet_center(planet_center)

	visible = false
	set_process(true)
	
	missions_tab.visible = false;
	
	infinite_survival_texture_rect.visible = false
	infinite_survival_button.disabled = true
	

func on_missions_button_pressed() -> void:
	missions_tab.visible = true
	mode_tab.visible = false
	var first_btn = missions_tab.find_child("*Button", true) as Button
	if first_btn:
		first_btn.grab_focus()

func on_exit_mission_tab() -> void:
	missions_tab.visible = false
	mode_tab.visible = true
	var first_btn = mode_tab.find_child("*Button", true) as Button
	if first_btn:
		first_btn.grab_focus()

func on_infinite_button_pressed() -> void:
	level_selected.emit("infinite", marker_position)

func on_mission_selected_from_tab(mission_ID: String, current_marker_position: Vector2) -> void:
	level_selected.emit(mission_ID, current_marker_position)

func on_infinite_survival_button_hover() -> void:
	var marker_offset = Vector2(-300, -200)
	marker_position = planet_center + marker_offset
	
	infinite_survival_texture_rect.visible = true;
	infinite_survival_texture_rect.set_global_position(marker_position)
	
	var fade_time = 0.2 
	var opacity = 1.0
	
	infinite_survival_texture_rect.modulate.a = 0.0
	mission_label.modulate.a = 0.0

	mission_label.text = infinite_hover_text
	
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
	infinite_survival_button.connect("focus_entered", Callable(self, "on_infinite_survival_button_hover"))
	infinite_survival_button.connect("focus_exited", Callable(self, "on_infinite_survival_button_hover_exit"))
