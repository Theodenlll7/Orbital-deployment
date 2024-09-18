class_name MainMenu
extends Control

@onready var select_mission_button: Button = $ContentMarginContainer/HBoxContainer/VBoxContainer/SelectMissionButton
@onready var options_button: Button = $ContentMarginContainer/HBoxContainer/VBoxContainer/OptionsButton 
@onready var exit_button: Button = $ContentMarginContainer/HBoxContainer/VBoxContainer/ExitButton 
@onready var ship: Control = $ship

@onready var animation_player_ship: AnimationPlayer = $ship/AnimationPlayer

@onready var mission_select_menu: Control = $mission_select
@onready var options_menu: OptionsMenu = $options_menu
@onready var main_menu: MarginContainer = $ContentMarginContainer

@onready var animation_player: AnimationPlayer = $transistion_content/AnimationPlayer

var target_menu: Control = null

func _ready() -> void:
	handle_connecting_signals()

func on_animation_finished(animation_name: String) -> void:
	if animation_name == "to_new_scene":
		change_menu()

func on_select_mission_button_pressed() -> void:
	animation_player.play("to_new_scene")
	target_menu = mission_select_menu

func on_exit_mission_select_menu() -> void:
	animation_player.play("to_new_scene")
	target_menu = main_menu

	
func on_options_button_pressed() -> void:
	target_menu = options_menu
	main_menu.visible = false
	options_menu.visible = true
	
func on_exit_options_menu() -> void:
	target_menu = main_menu 
	main_menu.visible = true
	options_menu.visible = false

func on_exit_button_pressed() -> void:
	get_tree().quit()
	
func change_menu() -> void:
	animation_player.play("in_new_scene")

	if target_menu == options_menu:
		main_menu.visible = false
		options_menu.visible = true
		mission_select_menu.visible = false
	elif target_menu == mission_select_menu:
		animation_player_ship.play("select_mission_ship_position")
		main_menu.visible = false
		options_menu.visible = false
		mission_select_menu.visible = true
	else: 
		animation_player_ship.play("init_dropship")
		main_menu.visible = true
		options_menu.visible = false
		mission_select_menu.visible = false

func handle_connecting_signals() -> void:
	select_mission_button.button_down.connect(on_select_mission_button_pressed)
	mission_select_menu.back_to_main_menu.connect(on_exit_mission_select_menu)
		
	options_button.button_down.connect(on_options_button_pressed)
	options_menu.back_to_main_menu.connect(on_exit_options_menu)
	
	exit_button.button_down.connect(on_exit_button_pressed)
	
	var signal_handler = Callable(self, "on_animation_finished")
	animation_player.connect("animation_finished", signal_handler)
