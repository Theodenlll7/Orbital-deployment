extends Control
class_name PauseInGame

@onready var main_menu = load("res://ui/main_menu/main_menu.tscn")

@onready var options_button: Button = $MarginContainer/TextureRect/MarginContainer/VBoxContainer/Buttons/MarginContainer/HBoxContainer/VBoxContainer/OptionsButton
@onready var resume_game_button: Button = $MarginContainer/TextureRect/MarginContainer/VBoxContainer/Buttons/MarginContainer/HBoxContainer/VBoxContainer/ResumeGameButton
@onready var restart_mission_button: Button = $MarginContainer/TextureRect/MarginContainer/VBoxContainer/Buttons/MarginContainer/HBoxContainer/VBoxContainer/RestartMissionButton
@onready var quit_level_button: Button = $MarginContainer/TextureRect/MarginContainer/VBoxContainer/Buttons/MarginContainer/HBoxContainer/VBoxContainer/QuitLevelButton
@onready var options_menu: OptionsMenu = $options_menu
@onready var pause_menu: MarginContainer = $MarginContainer

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

func on_restart_mission_button_pressed() -> void:
	Engine.time_scale = 1
	get_tree().reload_current_scene()

func on_back_from_options_button_pressed() -> void:
	options_menu.visible = false
	pause_menu.visible = true

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
		
	
