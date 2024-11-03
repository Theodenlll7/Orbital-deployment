extends Control

@export var mission_container : Container

@onready var back_button: Button = $VBoxContainer/BackButton

@onready var mission_marker: Control = $mission_marker

@export var mission_info_panel : MissionInfoPanel

signal back_mission_select
signal tab_level_selected(mission_ID, mission_position)

var planet_center = Vector2()
var marker_position = Vector2()

func _ready() -> void:
	handle_connecting_signals()
	mission_marker.visible = false

func on_mission_button_pressed(id: String) -> void:
	tab_level_selected.emit(id, marker_position)

func on_back_pressed() -> void:
	back_mission_select.emit()
	
func set_planet_center(new_center: Vector2) -> void:
	planet_center = new_center
	
func on_mission_button_hover(mission_number: String) -> void:
	var mission = MissionManager.get_mission_by_id(mission_number)
	
	mission_info_panel.set_mission(mission)
	
	var marker_offset = mission.marker_offset
	marker_position = planet_center + marker_offset
	
	mission_marker.visible = true;
	mission_marker.set_global_position(marker_position)
	
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
	mission_button.button_down.connect(on_mission_button_pressed.bind(mission_index))

func handle_connecting_signals() -> void:
	for mission in MissionManager.missions:
		var button = Button.new()
		mission_container.add_child(button)
		button.text = MissionManager.getMissionName(mission)
		set_button_connection(button, mission)
		button.custom_minimum_size = Vector2(256, 64)
		button.update_minimum_size()
		
		
	back_button.button_down.connect(on_back_pressed)
	return
