extends Control
class_name PauseInGame

@onready var main_menu = load("res://ui/main_menu/main_menu.tscn")

@onready var resume_game_button: Button = $MarginContainer/VBoxContainer/MarginContainer/PauseMenu/ResumeGameButton
@onready var options_button: Button = $MarginContainer/VBoxContainer/MarginContainer/PauseMenu/OptionsButton
@onready var restart_mission_button: Button = $MarginContainer/VBoxContainer/MarginContainer/PauseMenu/RestartMissionButton
@onready var quit_level_button: Button = $MarginContainer/VBoxContainer/MarginContainer/PauseMenu/QuitLevelButton

@onready var pause_menu := $MarginContainer/VBoxContainer/MarginContainer/PauseMenu
@onready var options_menu: OptionMenu = $MarginContainer/VBoxContainer/MarginContainer/options_menu

func _ready() -> void:
	handle_connecting_signals()
	options_menu.visible = false
	
func on_quit_level_button_pressed() -> void:
	Engine.time_scale = 1
	get_tree().change_scene_to_packed(main_menu)

func on_resume_game_button_pressed() -> void:
	var parent_hud = get_parent() as PlayerHUD  
	pause_menu.visible = false
	parent_hud.pauseMenu()

func on_options_button_pressed() -> void:
	options_menu.visible = true
	pause_menu.visible = false
	var first_btn = options_menu.find_child("*Button", true) as Button
	if first_btn:
		first_btn.grab_focus()

func on_restart_mission_button_pressed() -> void:
	Engine.time_scale = 1
	get_tree().reload_current_scene()

func on_back_from_options_button_pressed() -> void:
	options_menu.visible = false
	pause_menu.visible = true
	first_btn_focus_grab()
	
func first_btn_focus_grab() -> void:
	var first_btn = pause_menu.find_child("*Button", true) as Button
	if first_btn:
		first_btn.grab_focus()

func handle_connecting_signals() -> void:
	quit_level_button.button_down.connect(on_quit_level_button_pressed)
	resume_game_button.button_down.connect(on_resume_game_button_pressed)
	restart_mission_button.button_down.connect(on_restart_mission_button_pressed)
	options_button.button_down.connect(on_options_button_pressed)
	options_menu.back_to_main_menu.connect(on_back_from_options_button_pressed)
	
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		pause_menu.visible = true
		options_menu.visible = false
		first_btn_focus_grab()

		
	
