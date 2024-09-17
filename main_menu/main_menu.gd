class_name MainMenu
extends Control

@onready var start_button: Button = $ContentMarginContainer/HBoxContainer/VBoxContainer/StartButton 
@onready var options_button: Button = $ContentMarginContainer/HBoxContainer/VBoxContainer/OptionsButton 
@onready var exit_button: Button = $ContentMarginContainer/HBoxContainer/VBoxContainer/ExitButton 

@onready var animation_player_transition: AnimationPlayer = $transistion_content/AnimationPlayer

@onready var options_menu: OptionsMenu = $options_menu
@onready var content_margin_container: MarginContainer = $ContentMarginContainer

const start_level = preload("res://scenes/level1.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	handle_connecting_signals()
	
func on_start_button_pressed() -> void:
	animation_player_transition.play("to_new_scene")
	#get_tree().change_scene_to_packed(start_level)
	animation_player_transition.connect("animation_finished", Callable(self, "_on_animation_finished").bind("start_level"))

func on_options_button_pressed() -> void:
	content_margin_container.visible = false
	options_menu.visible = true
	options_menu.set_process(true)

func on_exit_button_pressed() -> void:
	get_tree().quit()

func on_exit_options_menu() -> void:
	content_margin_container.visible = true
	options_menu.visible = false

func _on_animation_finished(anim_name: String, scene_to_load: String) -> void:
	print(scene_to_load)
	if scene_to_load == "start_level":
		get_tree().change_scene_to_packed(start_level)

func handle_connecting_signals() -> void:
	start_button.button_down.connect(on_start_button_pressed)
	options_button.button_down.connect(on_options_button_pressed)
	exit_button.button_down.connect(on_exit_button_pressed)
	options_menu.back_to_main_menu.connect(on_exit_options_menu)
	
