class_name MainMenu
extends Control

@onready var start_button: Button = $MarginContainer/HBoxContainer/VBoxContainer/StartButton 
@onready var options_button: Button = $MarginContainer/HBoxContainer/VBoxContainer/OptionsButton 
@onready var exit_button: Button = $MarginContainer/HBoxContainer/VBoxContainer/ExitButton 
@onready var start_level: PackedScene = preload("res://scenes/world.tscn") 


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	handle_connecting_signals()

func on_start_button_pressed() -> void:
	get_tree().change_scene_to_packed(start_level)

func on_options_button_pressed() -> void:
	print("LOAD options")

func on_exit_button_pressed() -> void:
	get_tree().quit()

func handle_connecting_signals() -> void:
	start_button.button_down.connect(on_start_button_pressed)
	options_button.button_down.connect(on_options_button_pressed)
	exit_button.button_down.connect(on_exit_button_pressed)
	
