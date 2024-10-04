extends Control
class_name PauseInGame

@onready var main_menu = load("res://ui/main_menu/main_menu.tscn")

@onready var back_button: Button = $MarginContainer/BackButton
@onready var quit_level_button: Button = $MarginContainer/TextureRect/MarginContainer/VBoxContainer/Buttons/MarginContainer/HBoxContainer/VBoxContainer/QuitLevelButton

func _ready() -> void:
	handle_connecting_signals()

func on_quit_level_button_pressed() -> void:
	Engine.time_scale = 1
	get_tree().change_scene_to_packed(main_menu)

func on_back_button_pressed() -> void:
	var parent_hud = get_parent() as PlayerHUD  
	parent_hud.pauseMenu()

func handle_connecting_signals() -> void:
	quit_level_button.button_down.connect(on_quit_level_button_pressed)
	back_button.button_down.connect(on_back_button_pressed)
